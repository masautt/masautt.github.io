#!/usr/bin/env bash
# Export self-contained, single-file HTML for each device.
#
#   ./export.sh                 # every device in _devices/
#   ./export.sh asus-c302       # just one (repeatable, space-separated)
#
# Output: _site/<slug>.standalone.html  (CSS + images inlined, works offline).
# The deploy copies _site/ into the hub's devices/, so they publish at
# https://masautt.github.io/devices/<slug>.standalone.html.
#
# Ported here from masautt/masautt.github.io during the 2026-07 cutover. It used to run
# against the hub's own _devices collection, which meant it only ever covered the four
# devices the hub had a copy of — asus-c101 lived only here, so it never got a standalone
# and 404'd. Running it where the data actually lives fixes that by construction.
#
# Source of the rendered HTML, in order of preference:
#   1. _site/<slug>/index.html          -> a local `jekyll build` (what CI does)
#   2. $SITE_URL/devices/<slug>/        -> the live deploy, for running this without Ruby
set -euo pipefail
cd "$(dirname "$0")"
SITE_URL="${SITE_URL:-https://masautt.github.io}"

# This site is built with `baseurl: /devices`, so its rendered HTML points at
# /devices/assets/... while the built tree has those files at _site/assets/...
# Strip the prefix when resolving locally, or every asset silently fails to inline.
BASEURL="/devices"

slugs=()
if [ "$#" -gt 0 ]; then
  for a in "$@"; do a="$(basename "$a")"; slugs+=("${a%.md}"); done
else
  shopt -s nullglob
  for f in _devices/*.md; do b="$(basename "$f")"; slugs+=("${b%.md}"); done
  shopt -u nullglob
fi
[ "${#slugs[@]}" -gt 0 ] || { echo "No devices found in _devices/"; exit 1; }

for slug in "${slugs[@]}"; do
  if [ -f "_site/$slug/index.html" ]; then
    src="_site/$slug/index.html"; base="_site"; mode="local _site/"
  else
    src="$SITE_URL$BASEURL/$slug/"; base="$SITE_URL"; mode="live $SITE_URL"
  fi
  out="_site/$slug.standalone.html"
  echo "-> $slug   (from $mode)"
  python3 - "$src" "$base" "$out" "$BASEURL" <<'PY'
import base64, os, re, sys
from urllib.parse import urljoin
from urllib.request import urlopen, Request

src, base, out, baseurl = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
REMOTE = base.startswith(("http://", "https://"))
MIME = {".jpg":"image/jpeg",".jpeg":"image/jpeg",".png":"image/png",
        ".webp":"image/webp",".gif":"image/gif",".svg":"image/svg+xml"}

def fetch(path_or_url, binary):
    if path_or_url.startswith(("http://","https://")):
        req = Request(path_or_url, headers={"User-Agent":"export.sh"})
        data = urlopen(req, timeout=30).read()
        return data if binary else data.decode("utf-8")
    with open(path_or_url, "rb" if binary else "r", encoding=None if binary else "utf-8") as fh:
        return fh.read()

def resolve(ref):
    """Turn a page-relative ref into something fetch() can read."""
    if ref.startswith("data:"):
        return None
    if ref.startswith(("http://","https://")):
        return ref
    if REMOTE:
        return urljoin(base.rstrip("/") + "/", ref.lstrip("/"))
    # Local: the page says /devices/assets/x, the tree has _site/assets/x.
    if baseurl and ref.startswith(baseurl + "/"):
        ref = ref[len(baseurl):]
    return os.path.join(base, ref.lstrip("/"))

def data_uri(ref):
    tgt = resolve(ref)
    if tgt is None:
        return None
    raw = fetch(tgt, binary=True)
    mime = MIME.get(os.path.splitext(ref.split("?")[0])[1].lower(), "application/octet-stream")
    return f"data:{mime};base64,{base64.b64encode(raw).decode()}"

html = fetch(src, binary=False)

# 1. Inline any external stylesheets referenced with <link rel="stylesheet">.
def inline_css(css):
    # also fold url(...) references inside the CSS into data URIs
    def repl(m):
        ref = m.group(1).strip("'\"")
        if ref.startswith("data:"):
            return m.group(0)
        try:
            uri = data_uri(ref)
            return f"url({uri})" if uri else m.group(0)
        except Exception:
            return m.group(0)
    return re.sub(r"url\(([^)]+)\)", repl, css)

def link_repl(m):
    tag = m.group(0)
    href = re.search(r'href=["\']([^"\']+)["\']', tag)
    if not href:
        return tag
    try:
        css = fetch(resolve(href.group(1)), binary=False)
    except Exception as e:
        sys.stderr.write(f"   ! could not inline CSS {href.group(1)}: {e}\n")
        return tag
    return "<style>\n" + inline_css(css) + "\n</style>"

html = re.sub(r'<link\b[^>]*rel=["\']stylesheet["\'][^>]*>', link_repl, html)

# 2. Inline <img> sources as data URIs.
def img_repl(m):
    tag = m.group(0)
    src_m = re.search(r'src=["\']([^"\']+)["\']', tag)
    if not src_m or src_m.group(1).startswith("data:"):
        return tag
    try:
        uri = data_uri(src_m.group(1))
    except Exception as e:
        sys.stderr.write(f"   ! could not inline image {src_m.group(1)}: {e}\n")
        return tag
    return tag[:src_m.start(1)] + uri + tag[src_m.end(1):] if uri else tag

html = re.sub(r"<img\b[^>]*>", img_repl, html)

# Sanity: a standalone file that still points at the network isn't standalone. Warn loudly
# rather than publish a file that breaks the moment it's opened offline.
leftover = re.findall(r'(?:src|href)=["\']((?:/|https?://)[^"\']+\.(?:png|jpe?g|webp|gif|svg|css))["\']', html)
os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
with open(out, "w", encoding="utf-8") as fh:
    fh.write(html)
kb = round(len(html.encode("utf-8"))/1024, 1)
warn = f"  (WARN {len(leftover)} unresolved asset refs: {leftover[:3]})" if leftover else ""
print(f"   wrote {out}  {kb} KB{warn}")
PY
done
echo "Done."
