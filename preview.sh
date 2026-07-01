#!/usr/bin/env bash
# Rough static preview (Python). Liquid tags will NOT render — for real output
# use `jekyll serve`. Handy on machines without Ruby (e.g. a Chromebook).
cd "$(dirname "$0")" && python3 -m http.server 4000
