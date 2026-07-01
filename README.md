# masautt.github.io

A running reference to the things in my life. Built with plain Jekyll (native to
GitHub Pages — no build config needed). Live at <https://masautt.github.io>.

## Structure

```
_config.yml              site config + the `devices` collection
_layouts/
  default.html           <head>, CSS link, page wrapper
  device.html            renders a device page from front-matter data
_includes/
  spec-icons.html        the shared inline-SVG icon set (one place, reused everywhere)
assets/
  css/site.css           all styling
  devices/               device photos
_devices/                ONE FILE PER DEVICE  <- this is where you add machines
devices/index.html       the fleet index (auto-lists everything in _devices/)
index.md                 home / hub landing
```

## Adding a new laptop

Copy `_devices/asus-c302.md`, rename it (`_devices/<slug>.md`), and edit the
front matter. You don't touch HTML or CSS — the `device` layout renders it.

Each `specs` entry has an `icon` chosen from the set in
`_includes/spec-icons.html`: `cpu ram storage display os battery weight ports
price support calendar link`. Need a new one? Add a `{% when "foo" %}` branch
there and it's available to every device.

- `status:` `active` | `retired` | `stored` (drives the top-left badge)
- `measured:` optional "as actually detected" callout (Markdown)
- body (below the `---`) is the free-form story, in Markdown

## Standalone HTML export

Each device also gets a self-contained single-file copy at
`devices/<slug>.standalone.html` — CSS and images inlined as data URIs, so it
works with no server and offline (email it, open by double-click).

```
./export.sh                # regenerate for every device
./export.sh asus-c302      # just one
```

It reads the *rendered* page: a local `_site/` build if present (run
`jekyll build` first), otherwise the live deploy at `SITE_URL`
(default <https://masautt.github.io>, so push + let Pages build first). Re-run
after editing a device to refresh its standalone copy.

**Automated:** you normally don't run this by hand. The
`.github/workflows/export-standalone.yml` Action builds the site with Jekyll and
re-runs `export.sh` on every push that touches a device page, committing the
refreshed standalone files back. Just add/edit a device and push — the
`.standalone.html` follows automatically.

## Preview locally

Needs Ruby + Jekyll (`gem install bundler jekyll`), then `jekyll serve`
(http://localhost:4000). No Ruby handy (e.g. on the Chromebook)? `./preview.sh`
serves a rough static preview with Python — good enough to eyeball layout, but
Liquid tags won't render.
