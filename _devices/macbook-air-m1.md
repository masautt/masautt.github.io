---
title: MacBook Air (M1, 2020)
slug: macbook-air-m1
short: MacBook Air
category: Laptop · Apple Silicon
tagline: Powerful, silent, and somehow still a letdown.
status: loaned            # active | retired | stored | loaned
compiled: 2026-07-01
order: 3
purchased: "Apr 10, 2021"
msrp: "$1,199"

hero: /assets/devices/macbook-air-m1-hero.png
hero_alt: Space Gray Apple MacBook Air (M1, 2020), open, front view

badges:
  - Refurbished · Apr 2021
  - { text: "1 external display max", class: "eol" }
  - Loaned to family · Jun 2026

specs:
  - { icon: cpu,      k: Chip,      v: "Apple M1",           note: "8-core CPU · 7-core GPU · 16-core NE" }
  - { icon: ram,      k: Memory,    v: "8 GB unified",       note: "best recollection — unconfirmed" }
  - { icon: storage,  k: Storage,   v: "512 GB SSD",         note: "from memory — unconfirmed" }
  - { icon: display,  k: Display,   v: "13.3″ 2560×1600",    note: "Retina · P3 · 400 nits" }
  - { icon: lock,     k: Ext. displays, v: "1 external max", note: "M1 hardware limit" }
  - { icon: os,       k: OS,        v: "macOS",              note: "shipped Big Sur 11" }
  - { icon: battery,  k: Battery,   v: "49.9 Wh",            note: "up to 18 hr web · fanless, silent" }
  - { icon: weight,   k: Weight,    v: "2.8 lb",             note: "1,290 g · Touch ID" }
  - { icon: ports,    k: Ports,     v: "2× Thunderbolt / USB 4<br>3.5 mm headphone", note: "USB4 · 40 Gb/s — that's everything" }
  - { icon: price,    k: Paid,      v: "$1,193",             note: "refurb · Apr 10 2021" }
  - { icon: calendar, k: Released,  v: "Nov 2020",           note: "model A2337 · never refreshed" }

measured_title: Config note
measured_label: "⌘ Some specs are from memory"
measured: |
  What's on the label is confirmed: **13.3″ M1, 8-core CPU, 7-core GPU** (the entry
  config, in Silver). The **8 GB RAM** and **512 GB SSD** are my best recollection of
  this refurbished unit — I gave it to my cousin in June 2026, so they're unverified.
  Anyone with the machine can confirm in two seconds via  → About This Mac.

story_title: Why I got it — and why it let me down

# Gallery hidden for now — no photos of my actual unit I like yet.
# The image files still live in assets/devices/; re-enable by uncommenting.
# gallery_title: Photos
# gallery:
#   - { src: /assets/devices/macbook-air-m1-studio.jpg, caption: "The M1 Air, lid open. (Space Gray shown — mine was Silver; representative photos until I get real shots of my unit.)", alt: "Apple MacBook Air M1 open, studio white background" }
#   - { src: /assets/devices/macbook-air-m1-open.jpg, caption: "Running Big Sur — the OS it shipped with.", alt: "MacBook Air M1 open showing the macOS Big Sur desktop" }
#   - { src: /assets/devices/macbook-air-m1-desk.jpg, caption: "The whole point: silent, thin, go-anywhere.", alt: "MacBook Air M1 open on a desk" }

cost:
  items:
    - { label: "Refurbished MacBook Air · Apr 10, 2021", amount: "$1,189.00" }
    - { label: "CA electronic waste recycling fee", amount: "$4.00" }
  total: "$1,193.00"

links:
  - { url: "https://support.apple.com/en-us/122212", label: "Apple: MacBook Air display support", note: "M1 = one external display" }
  - { url: "https://appleinsider.com/articles/20/11/11/how-apple-silicon-on-a-m1-mac-changes-monitor-support-and-what-you-can-connect", label: "AppleInsider: M1 monitor support", note: "same chip, capped on the laptops" }
  - { url: "https://mos.caldis.me/", label: "Mos — smooth scrolling for macOS", note: "the fix I never nailed" }
  - { url: "https://www.smoothscroll.net/", label: "SmoothScroll (Win & Mac)", note: "the other smooth-scroll app" }
  - { url: "https://steamcommunity.com/app/250900/discussions/0/5170673756533676612/", label: "Binding of Isaac: Repentance — no Mac support", note: "Windows-only" }
  - { url: "https://www.marketresearchfuture.com/reports/2-in-1-laptops-market-3948", label: "2-in-1 laptop market outlook", note: "convertibles on the rise" }
  - { url: "https://www.macrumors.com/2026/06/11/touchscreen-macbook-confirmed-leaker/", label: "MacRumors: touchscreen MacBook 'confirmed'", note: "…finally" }

credit: "Hero image: MacBook Air M1 product photo, background removed."
---

I still didn't have a Windows laptop I trusted to last — and I wasn't convinced any on
the market would survive the years I wanted. So in April 2021 I gambled on a
**refurbished M1 Air** instead, betting that Apple Silicon was powerful enough to just
*do everything*.

It mostly was. I was still let down. The reasons stacked up:

**The scrolling.** My Logitech mouse scrolled beautifully on Ubuntu, on Windows, even
on my C302 Chromebook. On macOS it was choppy and stuttery and I couldn't understand
why. Turns out third-party mice just scroll badly on macOS unless you bolt on a helper —
[Mos](https://mos.caldis.me/), [SmoothScroll](https://www.smoothscroll.net/), or Mac
Mouse Fix ([here's the whole rabbit hole](https://baty.net/posts/2025/03/fixing-the-terrible-scrolling-behavior-with-logitech-mx-master-on-mac-os/)).
I downloaded the smooth-scroll app and never got it feeling right.

**One monitor. Just one.** The M1 Air is hardware-locked to a
[single external display](https://support.apple.com/en-us/122212) — and it stung more
when I found out the [M1 Mac *mini* could drive two](https://support.apple.com/en-us/102194).
Same chip, [plenty powerful](https://appleinsider.com/articles/20/11/11/how-apple-silicon-on-a-m1-mac-changes-monitor-support-and-what-you-can-connect),
artificially capped on the laptop.

> A total hardware lock — and it made me angrier once I knew the silicon could clearly handle it.

**Binding of Isaac.** Then Nicalis simply
[stopped supporting the Mac version of Repentance](https://steamcommunity.com/app/250900/discussions/0/5170673756533676612/) —
Windows-only from then on. That one genuinely made me sad.

**No tablet mode.** The biggest realization: I don't think I'll ever buy a
non-convertible laptop again. Not really for tablet mode — it's that I live by standing
a 2-in-1 on my wooden stand in presentation mode with the keyboard and mouse tucked
underneath. (Turns out [I'm not alone — convertibles are on the rise](https://www.marketresearchfuture.com/reports/2-in-1-laptops-market-3948).)

And honestly: how is it **2026** and there's *still* no touchscreen MacBook? I know it'd
eat into iPad sales — but come on. It's finally
[reportedly coming](https://www.macrumors.com/2026/06/11/touchscreen-macbook-confirmed-leaker/),
maybe [2027 with OLED and touch](https://appleinsider.com/articles/26/06/26/oled-touchscreen-and-more-what-to-expect-from-the-2027-macbook-pro).
When there's a foldable, touchscreen Mac, I'll probably buy again.

I made a few runs at it over the years — building iOS apps, trying it as a little
server — but I finally gave up in **June 2026** and handed it to my cousin as her daily
driver. I still feel a little bad: at coffee shops she ends up hugging the wall to keep
it charged.
