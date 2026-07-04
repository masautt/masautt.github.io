# Multi-repo → one `masautt.github.io` — design

**Date:** 2026-07-04
**Status:** approved design, pre-implementation

## Goal

Let several content projects live in their own repos under the `masautt-inc` org and
publish together into the single personal site at `masautt.github.io`, each at its own
path (`/devices`, and future endpoints). Adding or updating a project should not require
touching a web of files.

## Decisions (settled)

1. **Boundary = content-only projects (model A).** Project repos hold *content, data, and
   images only*. The umbrella owns all rendering machinery (layouts, CSS, includes,
   section index pages, config, build workflow).
2. **Delivery = manifest-driven build-time fetch.** A `projects.yml` registry in the
   umbrella lists each project and where its content mounts. The build clones each
   project's latest `main` and copies content into the Jekyll tree before building.
3. **Trigger = manual (umbrella-only).** Publishing is a manual kick of the umbrella
   build (`gh workflow run pages.yml` or the Actions "Run workflow" button). No schedule,
   **no workflow or token in any project repo.**

## Non-goals

- No instant auto-publish on project push (rejected: it requires a workflow/token in each
  project repo, or a hosted webhook/GitHub-App proxy). Revisit later if wanted.
- No per-project templates yet. A brand-new *content type* still needs its rendering added
  to the umbrella (see "Adding a section").
- Not a monorepo.

## Architecture

Three pieces:

- **Umbrella repo** — `masautt/masautt.github.io` (personal account). Owns:
  `_layouts/` (`default.html`, `device.html`), `assets/css/site.css`,
  `_includes/spec-icons.html`, `index.md` (home), `devices/index.html` (fleet + compare
  rendering), favicon assets, `_config.yml`, `.github/workflows/pages.yml`, plus the new
  `projects.yml` registry and `scripts/assemble.py`. The `_devices/` and `assets/devices/`
  directories **leave version control here** — they become gitignored and are populated at
  build time.

- **Project repos** — e.g. `masautt-inc/devices`. Content only:
  `_devices/*.md` + `assets/devices/*`. No layouts, no workflow, no token, no config.

- **Registry** — `projects.yml` in the umbrella:

  ```yaml
  projects:
    - repo: masautt-inc/devices
      ref: main
      mounts:
        - { from: _devices,       to: _devices }
        - { from: assets/devices, to: assets/devices }
  ```

  One entry per project. `from` is a path inside the project repo; `to` is the destination
  inside the umbrella's Jekyll source tree.

## Build / assemble flow

```
trigger: workflow_dispatch (manual) OR push to umbrella main
  → checkout umbrella
  → scripts/assemble            # reads projects.yml; per project:
                                #   shallow git clone (ref) using PROJECTS_READ_TOKEN
                                #   copy each mount (from → to) into the tree
  → jekyll build
  → regenerate devices/*.standalone.html   # existing step, unchanged
  → deploy to GitHub Pages
```

`scripts/assemble` is the single source of truth for "how content lands in the tree," and
is shared by **CI and local dev**. It:

- parses `projects.yml`,
- for each project, clones `https://x-access-token:$PROJECTS_READ_TOKEN@github.com/<repo>`
  at `ref` (depth 1) into a temp dir,
- clears each `to` destination and copies `from` → `to`,
- fails the build loudly if a project can't be cloned or a `from` path is missing.

## Trigger model (manual)

- `pages.yml` keeps `workflow_dispatch` (already present) and `push` on umbrella `main`.
- **No `schedule`. No `repository_dispatch`. No project-side workflow.**
- Publish a project change with `gh workflow run pages.yml --ref main` (or the button).

## Auth

- **`PROJECTS_READ_TOKEN`** — a fine-grained PAT with **Contents: read** on the
  `masautt-inc` content repos, stored as an Actions secret in the umbrella. Used by
  `scripts/assemble` to clone private project repos. This is the **only** token in the
  system.
- Note: the umbrella may be public and the published site is public regardless — keeping
  content *source* in a private `masautt-inc` repo does **not** make the rendered content
  private. That is expected for a public personal site.

## Umbrella repo changes

- Add `projects.yml` (registry).
- Add `scripts/assemble.py` (Python — consistent with the existing render scripts; no Ruby
  needed; parses `projects.yml`, clones each project, copies mounts).
- Add `_devices/` and `assets/devices/` to `.gitignore` (now build-populated).
- `_config.yml`: ensure `exclude` covers `scripts/`, `projects.yml`, `docs/` so they don't
  publish; the `devices` collection config stays (it renders assembled content).
- `pages.yml`: run `scripts/assemble` (with the token) before `jekyll build`.

## Local development / preview

No Ruby locally, so previews use the existing Python render scripts, not `jekyll serve`.

- `scripts/assemble` runs locally too (clones projects into the umbrella tree, or points at
  a local checkout of a project via an env override for offline work).
- After assembling, the existing `render_index.py` / `render_preview.py` render standalone
  HTML previews from the populated tree — unchanged.

## First increment (what we build first)

Prove the whole pipeline with **one** project:

1. Create `masautt-inc/devices` (private); move `_devices/*` and `assets/devices/*` into it;
   push.
2. In the umbrella: add `projects.yml` (devices entry), add `scripts/assemble`, gitignore
   `_devices/` + `assets/devices/`, and remove those now-migrated files from the umbrella.
3. Create `PROJECTS_READ_TOKEN`, add it as an umbrella Actions secret.
4. Update `pages.yml` to assemble before build.
5. Verify: trigger the umbrella build → devices content is cloned, site builds, `/devices`
   is live and identical to before. Then edit a device in `masautt-inc/devices`, re-run the
   umbrella build, confirm the change publishes.

## Adding a section later

- **Another same-type collection** (more devices-like content): new `masautt-inc/<name>`
  repo + one `projects.yml` entry. No umbrella template work.
- **A new content *type*** (different rendering): the above **plus** its rendering in the
  umbrella (a layout + a section index page + any new icons). This is the model-A tradeoff,
  accepted for simplicity.

## Risks / edge cases

- **Token expiry** — fine-grained PATs expire; a failed clone fails the build with a clear
  message. Document rotation.
- **Floating `main`** — builds pull latest `main` of each project (not pinned). Acceptable;
  a bad content commit is fixed by another content commit + rebuild.
- **Pages deploy rate limit** — GitHub Pages ~10 builds/hour; rapid manual rebuilds can hit
  "Deployment failed, try again later" with a green status page — wait/retry (see
  [[project_masautt_github_io]]).
- **Standalone-export auto-commit** — the existing step still commits `*.standalone.html`
  to the umbrella; it reads the built (assembled) tree, so it keeps working.
- **Empty/missing mount** — assemble fails fast rather than deploying a half-built site.

## Verification

- After the first increment: `/devices/` renders identically to the pre-migration site
  (spot-check specs, compare table, heroes), and an edit in `masautt-inc/devices` shows up
  after an umbrella rebuild.
- `git grep` in the umbrella confirms no `_devices/*.md` or device images remain committed
  there.
