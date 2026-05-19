#!/usr/bin/env bash
# Re-encodes the photos in images/ + the OG card at root into AVIF + WebP variants.
# Source photos are 591x1280 — already phone-sized — so we don't downscale.
# The "mobile" hero variant uses lower quality at the same resolution to save more bytes.
# Re-run any time you swap source photos.
set -euo pipefail
cd "$(dirname "$0")/.."

command -v cwebp   >/dev/null || { echo "Install cwebp:   brew install webp"; exit 1; }
command -v avifenc >/dev/null || { echo "Install avifenc: brew install libavif"; exit 1; }

# Desktop quality — visually indistinguishable from JPEG q=85
WEBP_Q=78
AVIF_Q=55           # AVIF perceptual: 55 ≈ JPEG q=85 (lower number = higher quality in avifenc --max)
AVIF_SPEED=4        # 0=slowest/smallest, 10=fastest. 4 is the sweet spot.

# Mobile quality — slightly more aggressive
WEBP_Q_MOBILE=70
AVIF_Q_MOBILE=60

# Gallery photos + hero — live in images/
for src in images/image2.jpg images/image3.jpg images/image4.jpg images/image5.jpg images/image6.jpg images/image7.jpg; do
  [[ -f "$src" ]] || { echo "skip: $src not found"; continue; }
  base="${src%.jpg}"
  echo "→ $src"
  cwebp   -q $WEBP_Q   -m 6 -mt -quiet "$src" -o "$base.webp"
  avifenc --min 0 --max $AVIF_Q --speed $AVIF_SPEED --jobs all "$src" "$base.avif" >/dev/null
done

# Social-share OG card — stays at repo root (referenced by absolute URL in og:image meta)
if [[ -f og-card.jpg ]]; then
  echo "→ og-card.jpg"
  cwebp   -q $WEBP_Q   -m 6 -mt -quiet og-card.jpg -o og-card.webp
  avifenc --min 0 --max $AVIF_Q --speed $AVIF_SPEED --jobs all og-card.jpg og-card.avif >/dev/null
fi

# Mobile hero variant — same source as desktop hero, more aggressive compression
echo "→ images/image5-mobile (more aggressive compression for phones)"
cp images/image5.jpg images/image5-mobile.jpg
cwebp   -q $WEBP_Q_MOBILE   -m 6 -mt -quiet images/image5-mobile.jpg -o images/image5-mobile.webp
avifenc --min 0 --max $AVIF_Q_MOBILE --speed $AVIF_SPEED --jobs all images/image5-mobile.jpg images/image5-mobile.avif >/dev/null

echo
echo "Size report (sorted):"
ls -lS images/image*.{jpg,webp,avif} og-card.{jpg,webp,avif} 2>/dev/null | awk '{printf "  %-40s %8s\n", $NF, $5}'
