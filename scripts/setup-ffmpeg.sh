#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$ROOT_DIR/tools/ffmpeg"
FFMPEG_BIN="$TOOLS_DIR/ffmpeg"

if command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg already available in PATH"
  exit 0
fi

if [[ -x "$FFMPEG_BIN" ]]; then
  echo "ffmpeg already available at $FFMPEG_BIN"
  exit 0
fi

mkdir -p "$TOOLS_DIR"
ARCHIVE="$TOOLS_DIR/ffmpeg-release-amd64-static.tar.xz"
URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"

echo "Downloading ffmpeg static build..."
curl -fsSL "$URL" -o "$ARCHIVE"

echo "Extracting ffmpeg..."
tar -xf "$ARCHIVE" -C "$TOOLS_DIR"
EXTRACTED_DIR="$(find "$TOOLS_DIR" -maxdepth 1 -type d -name 'ffmpeg-*-amd64-static' | head -n 1)"
cp "$EXTRACTED_DIR/ffmpeg" "$FFMPEG_BIN"
chmod +x "$FFMPEG_BIN"

echo "ffmpeg ready at $FFMPEG_BIN"
