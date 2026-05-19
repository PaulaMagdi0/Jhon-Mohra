#!/usr/bin/env bash
# Re-encodes every JPEG in the repo root into AVIF + WebP variants.
# Source photos are 591x1280 — already phone-sized — so we don't downscale.
# Instead, the "mobile" variants use lower quality to save more bytes.
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

for src in image2.jpg image3.jpg image4.jpg image5.jpg image6.jpg image7.jpg og-card.jpg; do
  [[ -f "$src" ]] || { echo "skip: $src not found"; continue; }
  base="${src%.jpg}"
  echo "→ $src"
  cwebp   -q $WEBP_Q   -m 6 -mt -quiet "$src" -o "$base.webp"
  avifenc --min 0 --max $AVIF_Q --speed $AVIF_SPEED --jobs all "$src" "$base.avif" >/dev/null
done

# Mobile hero variant — same source, more aggressive compression
echo "→ image5-mobile (more aggressive compression for phones)"
cp image5.jpg image5-mobile.jpg
cwebp   -q $WEBP_Q_MOBILE   -m 6 -mt -quiet image5-mobile.jpg -o image5-mobile.webp
avifenc --min 0 --max $AVIF_Q_MOBILE --speed $AVIF_SPEED --jobs all image5-mobile.jpg image5-mobile.avif >/dev/null

echo
echo "Size report (sorted):"
ls -lS image*.{jpg,webp,avif} og-card.{jpg,webp,avif} 2>/dev/null | awk '{printf "  %-30s %8s\n", $NF, $5}'
