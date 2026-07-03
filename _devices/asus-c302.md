---
title: ASUS Chromebook Flip C302CA
slug: asus-c302
short: C302
category: Laptop · Convertible Chromebook
tagline: The college battery-life machine, revived in 2026.
status: active            # active | retired | stored | loaned
compiled: 2026-07-01
order: 4
purchased: "Feb 7, 2018"

hero: /assets/devices/asus-c302-hero.png
hero_alt: ASUS Chromebook Flip C302 shown in multiple 360-degree hinge positions

badges:
  - Bought Feb 2018
  - { text: "ChromeOS EOL Jun 2023", class: "eol" }
  - "Now: Debian via Crostini"

specs:
  - { icon: cpu,     k: Processor, v: "Intel Core m3-6Y30", note: "Skylake · 0.90 GHz" }
  - { icon: ram,     k: Memory,    v: "4 GB LPDDR3",        note: "soldered · non-upgradeable" }
  - { icon: storage, k: Storage,   v: "64 GB eMMC",         note: "+ microSD slot" }
  - { icon: display, k: Display,   v: "12.5″ 1920×1080",    note: "IPS touch · 360° flip" }
  - { icon: os,      k: OS today,  v: "Debian 11 (Crostini)", note: "kernel 5.15.108" }
  - { icon: battery, k: Battery,   v: "39 Wh",               note: "~10 hr real-world · the reason I bought it" }
  - { icon: weight,  k: Weight,    v: "2.6 lb",             note: "1,180 g · aluminum" }
  - { icon: ports,   k: Ports,     v: "2× USB-C (3.1 Gen 1)<br>microSD<br>3.5 mm headphone", note: "both USB-C charge + display out" }
  - { icon: price,   k: Paid,      v: "$510.35",            note: "all-in · Feb 7 2018" }
  - { icon: support, k: Support,   v: "2017 – Jun 2023",    note: "~6 yrs of ChromeOS updates" }
  - { icon: calendar, k: Released, v: "Jan 2017",           note: "announced at CES 2017" }

measured_title: As measured (2026)
measured_label: "◈ Live readout from inside the Crostini container"
measured: |
  The Linux sandbox only sees a slice of the hardware: `4 vCPU`, `2.7 GiB RAM`,
  and a `10 GB` container disk (2.5 GB used). Toolchain detected: `python 3.9.2`,
  `git 2.30.2`, `gh 2.95.0`. The numbers above are the *real* hardware; these are
  what code actually runs against.

story_title: Why I have it

gallery_title: Inside
gallery:
  - { src: /assets/devices/asus-c302-teardown.jpg, caption: "Cracked open — battery, logic board, and speakers mid-repair.", alt: "ASUS C302 opened up showing the battery and logic board" }

cost:
  items:
    - { label: "Chromebook · Feb 7, 2018", amount: "$469.00" }
    - { label: "CA electronic waste recycling fee", amount: "$5.00" }
    - { label: "Sales tax", amount: "$36.35" }
  total: "$510.35"

links:
  - { url: "https://github.com/dnschneid/crouton", label: "dnschneid/crouton", note: "the chroot tool I used (now EOL)" }
  - { url: "https://support.google.com/chrome/a/answer/6220366", label: "Google ChromeOS Auto Update policy", note: "AUE dates" }
  - { url: "https://www.ifixit.com/Device/Chromebook_Flip_C302", label: "iFixit teardown & repair guide", note: "" }

credit: "Hero & teardown photos © iFixit, CC BY-NC-SA 3.0."
---

I bought this in college because I needed something with **great battery life** — something
that would survive a full day of classes without a charger. On that promise, it delivered.

> The frustration was everything else: it's a Chromebook. Getting it dev-tooled was a constant
> fight, because it isn't real Linux — it's a *special* Linux.

So much of the standard Linux world just… didn't apply, and a lot of things I couldn't fix simply
because the platform wouldn't let me. For a while I ran [Crouton](https://github.com/dnschneid/crouton)
to get a usable chroot with actual tooling — which worked until it didn't (Crouton itself is now EOL).

Now, in **2026**, I'm reviving it with Claude — and I'm genuinely surprised how much I can still put
on here. Three years past its official ChromeOS end-of-life, it's back to being a real dev machine.
