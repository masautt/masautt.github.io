#!/usr/bin/env bash
# Export self-contained, single-file HTML for devices.
#
#   ./export.sh                 # every device in _devices/
#   ./export.sh asus-c302       # just one (repeatable, space-separated)
#
# Output: devices/<slug>.standalone.html  (CSS + images inlined, works offline).
#
# Source of the rendered HTML, in order of preference:
#   1. _site/devices/<slug>/index.html   -> if you ran `jekyll build` locally
#   2. $SITE_URL/devices/<slug>/         -> the live deploy (default; needs the
#                                           latest changes already pushed+built)
# Override the live base with:  SITE_URL=https://example.com ./export.sh
set -euo pipefail
cd "$(dirname "$0")"
SITE_URL="${SITE_URL:-https://masautt.github.io}"

# Collect slugs: args if given, else every _devices/*.md filename.
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
  if [ -f "_site/devices/$slug/index.html" ]; then
    src="_site/devices/$slug/index.html"; base="_site"; mode="local _site/"
  else
    src="$SITE_URL/devices/$slug/"; base="$SITE_URL"; mode="live $SITE_URL"
  fi
  out="devices/$slug.standalone.html"
  echo "-> $slug   (from $mode)"
  python3 - "$src" "$base" "$out" <<'PY'
import base64, os, re, sys
from urllib.parse import urljoin
from urllib.request import urlopen, Request

src, base, out = sys.argv[1], sys.argv[2], sys.argv[3]
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
    return os.path.join(base, ref.lstrip("/"))

def data_uri(ref):
    tgt = resolve(ref)
    if tgt is None:
        return None
    raw = fetch(tgt, binary=True)
    mime = MIME.get(os.path.splitext(ref.split("?")[0])[1].lower(), "application/octet-stream")
    return f"data:{mime};base64,{base64.b64encode(raw).decode()}"

html = fetch(src if src.startswith(("http://","https://","/")) or os.path.exists(src) else src, binary=False)

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

# Sanity: nothing external should remain.
leftover = re.findall(r'(?:src|href)=["\'](/assets/[^"\']+)["\']', html)
os.makedirs(os.path.dirname(out), exist_ok=True)
with open(out, "w", encoding="utf-8") as fh:
    fh.write(html)
kb = round(len(html.encode("utf-8"))/1024, 1)
warn = f"  (WARN {len(leftover)} unresolved asset refs)" if leftover else ""
print(f"   wrote {out}  {kb} KB{warn}")
PY
done
echo "Done."
