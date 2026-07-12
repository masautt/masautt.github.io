# devices → masautt.github.io/devices — design, status & cutover plan

**Status:** built & CI-verified; **paused pending a deploy token + cutover.**
**Started:** 2026-07-02

---

## Goal

`masautt-inc` owns the **`/devices` section end-to-end** — data, presentation,
and deploy — while the section still serves from the user-owned
`https://masautt.github.io/devices/`.

## Why this shape

GitHub Pages user-sites are tied to the account: `masautt.github.io` can only be
served from a repo owned by the **`masautt` user** (moving it to `masautt-inc`
would change the URL and break it — no custom domain is set). So the site repo
must stay on the user account. This project reconciles that with "masautt-inc
owns my stuff" by making **`masautt-inc/devices` the source of truth** and the
Pages repo a thin host. It's the **first slice of the bigger vision**: several
`masautt-inc` repos building into subpaths of the one `masautt.github.io`
(cheatsheets etc. to follow), with data eventually coming from a **self-hosted
Supabase** at build time.

## Architecture (whole-built-section, push model)

```
masautt-inc/devices  (this repo, private)
  _devices/*.md        device data (front-matter)
  _layouts,_includes,assets  presentation (self-contained Jekyll, baseurl /devices)
  index.html           fleet-compare (section landing)
  .github/workflows/deploy.yml
      push→ jekyll build (_site) → checkout masautt/masautt.github.io (PAT)
          → replace its devices/ with _site/ → commit+push → Pages redeploys
```

- **Whole section, not just data:** this repo builds the HTML; the hub just hosts it.
- **Push model:** the job lives on THIS repo (per the decision), pushing to the hub.
- **baseurl `/devices`** so every `relative_url` resolves under the mount point;
  the "masautt" breadcrumb is hardcoded to `/` (hub root), the "devices"
  breadcrumb to the section root.

## Current status (2026-07-02)

- ✅ Repo created (`masautt-inc/devices`, private), section source copied from the
  hub, breadcrumbs adjusted, `_config.yml` (baseurl `/devices`), `Gemfile`,
  `deploy.yml`, README — committed & pushed.
- ✅ First CI run: **Jekyll build step passed** (config is valid). Deploy step
  failed **only** because `PAGES_DEPLOY_TOKEN` isn't set — expected.
- ✅ `masautt/masautt.github.io` **untouched** — live site still serves devices
  the old way (its own `_devices` collection).

## Remaining work — RESUME HERE

### 1. Create the deploy token (user, one-time)
Fine-grained PAT → resource owner **`masautt`**, repo **`masautt/masautt.github.io`**,
permission **Contents: Read and write**. Add to this repo:
`gh secret set PAGES_DEPLOY_TOKEN --repo masautt-inc/devices`.

### 2. Cutover (coordinated; ~1 min window)
The hub currently *also* generates `/devices/` — both can't. So:

a. **Hub-cleanup commit** in `masautt/masautt.github.io`: remove `_devices/`,
   `_layouts/device.html`, `_includes/spec-icons.html` (devices-only),
   `devices/index.html`, `assets/devices/`, the `devices` collection + its
   `defaults` in `_config.yml`, and the devices auto-export bits in `pages.yml` /
   `export.sh`. Fix the landing card image in `index.md`
   (`/assets/devices/asus-c302-hero.png` → `/devices/assets/devices/asus-c302-hero.png`).
b. **Run deploy:** `gh workflow run deploy.yml --repo masautt-inc/devices`.
c. **Verify** `https://masautt.github.io/devices/` (index + a device page +
   images + breadcrumb back to hub) now served from this repo.

### 3. After cutover
- Source of truth for devices = this repo. Edit here, push, it redeploys.
- The hub only owns the landing page + hosts the pushed `/devices/` static output.

## Open follow-ups / future
- Same pattern for **cheatsheets** (decision pending: LibDoc `learn-masautt` vs a
  Jekyll collection — see the masautt.github.io memory).
- A **platform-level spec** if/when multiple content repos + a real aggregator +
  self-hosted-Supabase build-time data land.
- Refresh triggers, once data is dynamic (webhook / cron / manual).
