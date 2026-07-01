---
title: ThinkPad T480s
slug: thinkpad-t480s
short: T480s
category: Laptop · Business Ultrabook
tagline: The layoff laptop — cheap, loaded with RAM, dual-booted to Linux.
status: retired            # active | retired | stored
compiled: 2026-07-01

hero: /assets/devices/thinkpad-t480s-hero.png
hero_alt: Lenovo ThinkPad T480s, black business ultrabook, open, front three-quarter view

badges:
  - Bought Dec 2023
  - Dual-boot · Ubuntu + Windows
  - First Windows since the Envy

specs:
  - { icon: cpu,      k: Processor, v: "Intel Core i7-8650U",  note: "Kaby Lake R · 4C/8T · up to 4.2 GHz" }
  - { icon: ram,      k: Memory,    v: "24 GB DDR4",           note: "8 GB soldered + 16 GB SODIMM" }
  - { icon: storage,  k: Storage,   v: "1 TB NVMe SSD",        note: "the roomy part" }
  - { icon: display,  k: Display,   v: "14″ FHD 1920×1080",    note: "IPS · anti-glare · non-touch" }
  - { icon: os,       k: OS,        v: "Ubuntu + Windows 10",  note: "dual-boot via GRUB" }
  - { icon: battery,  k: Battery,   v: "57 Wh",                note: "internal · spec sheet (not yet measured)" }
  - { icon: weight,   k: Weight,    v: "1.32 kg",              note: "2.9 lb · magnesium chassis" }
  - { icon: ports,    k: Ports,     v: "2× USB-C · 2× USB-A",  note: "Thunderbolt 3 · HDMI · RJ45 · microSD" }
  - { icon: price,    k: Paid,      v: "$477.41",              note: "all-in · Dec 9 2023" }
  - { icon: calendar, k: Released,  v: "2018",                 note: "Q1 · Kaby Lake R" }

measured_title: As measured
measured_label: "◈ Live readout pending"
measured: |
  I wrote this page from my [ThinkPad X1](/devices/thinkpad-x1-2in1-gen10/), so I couldn't
  scrape the T480s live yet — the numbers above come from the listing and Lenovo's spec
  sheet. I'll drop in the real detected values next time I boot it: the exact RAM layout
  (`8 GB` soldered + a `16 GB` SODIMM), the SSD model, battery health, and cycle count.

benchmarks_title: How it compares to the X1
benchmarks_note: >-
  PassMark / cpubenchmark.net. The Core Ultra 7 268V in the ThinkPad X1 that replaced this
  is roughly 2× the single-thread and 3× the multi-thread — but for $477 in a pinch, the
  T480s punched well above its price.
benchmarks:
  - { cpu: "Core i7-8650U", arch: "Kaby Lake R · this laptop (2018)", st: "2,099", mt: "6,188", me: true }
  - { cpu: "Core Ultra 7 268V", arch: "Lunar Lake · the X1 that replaced it (2026)", st: "4,070", mt: "19,385" }

story_title: Why I got it

cost:
  items:
    - { label: "ThinkPad T480s · Dec 9, 2023", amount: "$439.00" }
    - { label: "Shipping", amount: "Free" }
    - { label: "Sales tax", amount: "$38.41" }
  total: "$477.41"

links:
  - { url: "https://ark.intel.com/content/www/us/en/ark/products/124968/intel-core-i7-8650u-processor-8m-cache-up-to-4-20-ghz.html", label: "Intel ARK — Core i7-8650U", note: "4C/8T · 15 W · Kaby Lake R" }
  - { url: "https://www.cpubenchmark.net/cpu.php?cpu=Intel+Core+i7-8650U+%40+1.90GHz&id=3070", label: "PassMark — Core i7-8650U", note: "the scores in the table above" }
  - { url: "https://psref.lenovo.com/Product/ThinkPad/ThinkPad_T480s", label: "Lenovo PSREF — ThinkPad T480s", note: "full platform spec" }
  - { url: "https://www.gnu.org/software/grub/", label: "GNU GRUB", note: "the bootloader that juggled Ubuntu + Windows" }

credit: "Hero image: official ThinkPad T480s product render, courtesy of Lenovo."
---

I bought this **a month into being laid off**, in December 2023. I needed something *cheap*
that could still do real, powerful work — and for **$477 all-in**, a used T480s with an i7,
**24 GB of RAM**, and a 1 TB SSD fit the bill exactly.

It was my **first Windows laptop since the HP Envy** — and a night-and-day upgrade. It was
more powerful, it finally had **USB-C**, and, crucially, it had none of the Envy's
headaches: no flaky network connectivity, no bloatware. It just worked.

> The RAM is what made it feel powerful for the money. Twenty-four gigs on a $477 laptop
> covered a lot of sins.

I **dual-booted** it with GRUB — Ubuntu alongside the old Windows install — and mostly
lived on the Linux side. I never loved dual-booting *into* Windows, though: it always
seemed to catch me in one of those restart-and-update loops right when I needed the machine.

I ran it for a few years as my daily driver, right up until I finally bought the
[ThinkPad X1](/devices/thinkpad-x1-2in1-gen10/). More detail to come here once I'm back on
the 480s to pull its live specs.
