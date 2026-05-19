# John & Mohra — Wedding Invitation

A single-file, bilingual (Arabic + English, RTL primary) wedding invitation web page for **John & Mohra · 26 May 2026**.

Everything — markup, styles, animations, music, RSVP form — lives in `index.html`. No build step, no backend, no dependencies. Open it in a browser and it works.

---

## What's inside

| Section | Notes |
|---|---|
| **Loading splash** | Wax-seal monogram with rotating ring; shows for 2.5–4s |
| **Envelope cover** | Tap the envelope to open the invitation; wax-seal animation + photo lift |
| **Hero** | Couple names with Jeremiah 32:39 verse in Arabic |
| **Welcome** | Optional per-guest greeting via `?to=` URL param |
| **Save the Date** | Date block + smart "Add to Calendar" (Google on desktop/Android, .ics on iOS) + WhatsApp share |
| **Countdown** | Live ticking countdown to 2026-05-26 17:00 Cairo, paused when tab hidden |
| **Event cards** | Church (5:00 PM) + Reception (7:00 PM) with map links |
| **Photo gallery** | Swipeable deck of `image2`–`image7`, keyboard arrows supported |
| **Timeline** | 4-step wedding-day schedule |
| **Good to Know** | Dress code · Parking · Family · Gifts (editable defaults) |
| **RSVP form** | Confirms attendance with confetti; **frontend-only** (no backend) |
| **Music** | Wagner's *Bridal Chorus* synthesized via WebAudio + hall reverb; toggle bottom-left |
| **Ambient** | 36 falling petal/star glyphs across the viewport |

---

## File structure

```
/
├── index.html              # the entire site
├── favicon.svg             # gold-coin J&M monogram
├── og-card.jpg             # 1200×630 social-share preview (WhatsApp, Twitter, etc.)
├── image2.jpg … image7.jpg # cover + gallery photos
└── README.md
```

---

## Common customisations

All of these are single-line edits in `index.html`.

### Change the envelope cover photo
Search for `<img src="image5.jpg"` and swap to any of `image2.jpg`–`image7.jpg`.
Also update the `<link rel="preload">` and `<meta og:image>` tags at the top of `<head>` to match.

### Tune photo framing inside the envelope
On `.env-photo`:
```css
--env-photo-zoom: 1;     /* 1 = natural fit; >1 crops in */
--env-photo-y: 50%;      /* 0% = top, 50% = middle, 100% = bottom */
```

### Personalise per recipient
Append `?to=NAME` to the URL:
```
…/index.html?to=Yara
```
The welcome card shows *"أهلاً يا Yara ✦"* and the RSVP name field auto-fills. Sanitised + capped at 40 chars.

### Update "Good to Know" copy
Find the `<!-- GOOD TO KNOW -->` section in the HTML — four `.info-item` blocks (Dress Code · Parking · Family · Gifts). Defaults are placeholders; edit the Arabic + English copy in place.

### Adjust the loading splash duration
Search for `SPLASH — wax-seal intro` in the `<script>` block:
```js
const MIN_MS = 2500;   // minimum show time (ms)
const MAX_MS = 4000;   // hard cap (ms)
```

### Brand palette
At the top of the `<style>` block under `DESIGN TOKENS`:
```css
--gold:          #c9a35b;
--gold-deep:     #9d7a2f;
--wine:          #6b1f2a;
--paper:         #fbf6ec;
```

---

## Deployment

It's a static page — host it anywhere:

- **GitHub Pages**: push to `main`, enable Pages → root → `/`.
- **Netlify / Vercel / Cloudflare Pages**: drag-and-drop the folder.
- **Direct file**: works from `file://` for local previews.

The site is currently configured for `https://jhon-mohra.vercel.app/` (see the `og:` meta tags). Update those URLs when you host elsewhere.

---

## Accessibility

- WCAG AA contrast on body text and interactive states
- `:focus-visible` rings on every interactive element
- `aria-live` announcements for RSVP confirmation
- `aria-hidden` on the collapsed invitation until the envelope is tapped
- Keyboard navigation for the photo deck (← / →)
- `prefers-reduced-motion` disables ambient particles and decorative animations
- English content wrapped in `<span lang="en">` so Arabic screen readers pronounce names correctly
- `dir="ltr"` on Latin-only blocks (cover names, splash monogram) inside the RTL document

---

## Browser support

Tested on modern Chrome, Safari, Firefox (desktop + iOS + Android). WebAudio music gracefully no-ops on older browsers.

---

## Credits

- Fonts: Playfair Display · Marck Script · Tajawal · Cormorant Garamond (Google Fonts)
- Verse: Jeremiah 32:39 (Arabic translation)
- Music: *Bridal Chorus* (Wagner, *Lohengrin*) — synthesized via WebAudio
- Photography: Couple's own

Made with love for **John & Mohra · 26 · 05 · 2026** 🤍
