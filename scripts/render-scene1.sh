#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS_DIR="$ROOT_DIR/assets/scene1"
OUTPUT_DIR="$ROOT_DIR/output"
PHOTO_PATH="$ASSETS_DIR/photo.jpg"
OUTPUT_PATH="$OUTPUT_DIR/scene1.mp4"
SCENE_DURATION="3.5"
FPS="30"
TOTAL_FRAMES="105"

if command -v ffmpeg >/dev/null 2>&1; then
  FFMPEG_BIN="$(command -v ffmpeg)"
else
  "$ROOT_DIR/scripts/setup-ffmpeg.sh"
  FFMPEG_BIN="$ROOT_DIR/tools/ffmpeg/ffmpeg"
fi

mkdir -p "$ASSETS_DIR" "$OUTPUT_DIR"

if [[ ! -f "$PHOTO_PATH" ]]; then
  echo "Error: required photo is missing at $PHOTO_PATH" >&2
  echo "Please place the uploaded first trip photo at assets/scene1/photo.jpg" >&2
  exit 1
fi

"$FFMPEG_BIN" -y \
  -i "$PHOTO_PATH" \
  -f lavfi -t "$SCENE_DURATION" -i anullsrc=channel_layout=stereo:sample_rate=48000 \
  -filter_complex "
    [0:v]scale=1920:1080,zoompan=z='1+0.05*(on/${TOTAL_FRAMES})':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${TOTAL_FRAMES}:s=1920x1080:fps=${FPS},trim=duration=${SCENE_DURATION}[bg];
    color=c=black@0.0:s=220x100:d=${SCENE_DURATION},format=rgba,
      drawbox=x=20:y=38:w=150:h=30:color=#e53935:t=fill,
      drawbox=x=50:y=18:w=75:h=22:color=#ef5350:t=fill,
      drawbox=x=40:y=68:w=25:h=25:color=#263238:t=fill,
      drawbox=x=125:y=68:w=25:h=25:color=#263238:t=fill[car];
    [bg][car]overlay=x=(W-w)/2:y=H-h-36[v];
    sine=frequency=190:sample_rate=48000:duration=0.45,volume=0.12,adelay=250|250[a_engine];
    [1:a][a_engine]amix=inputs=2:duration=first:dropout_transition=0,atrim=duration=${SCENE_DURATION}[a]
  " \
  -map "[v]" -map "[a]" \
  -r "$FPS" \
  -c:v libx264 -pix_fmt yuv420p \
  -c:a aac -b:a 160k \
  -movflags +faststart \
  -shortest \
  "$OUTPUT_PATH"

echo "Done: $OUTPUT_PATH"
