#!/usr/bin/env bash

set -o nounset
set -o errexit

VIDEO_INPUT="$1"
SUBTITLE_INPUT="$2"
VIDEO_OUTPUT="$3"
VIDEO_BITRATE="6000k"

ffmpeg \
-y \
-i "$VIDEO_INPUT" \
-i "$SUBTITLE_INPUT" \
-vf "subtitles=$SUBTITLE_INPUT" \
-c:v libx264 \
-b:v "$VIDEO_BITRATE" \
-ac 2 \
-af "pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR" \
-sn \
-pass 1 \
-f mp4 \
/dev/null

ffmpeg \
-i "$VIDEO_INPUT" \
-i "$SUBTITLE_INPUT" \
-vf "subtitles=$SUBTITLE_INPUT" \
-c:v libx264 \
-b:v "$VIDEO_BITRATE" \
-ac 2 \
-af "pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR" \
-sn \
-pass 2 \
"$VIDEO_OUTPUT"
