#!/bin/bash
usage="usage:
    download_videos urls_file [max_width] [max_height]
        uses ffmpeg to download remote video urls and convert them to a desired pixel resolution

        urls_file is a file where each line is a video url and no newline at end
        max_width defaults to 1334 (iPhone 6 landscape width)
        max_height defaults to 750 (iPhone 6 landscape height)
"
die(){ echo "${usage}" >&2; exit 1; }

IPHONE_6_WIDTH=1334
IPHONE_6_HEIGHT=750

VIDEO_URLS_FILE=$1; shift
MAX_WIDTH=$1; shift
MAX_HEIGHT=$1;
MAX_WIDTH="${MAX_WIDTH:-$IPHONE_6_WIDTH}" #this notation defaults to iphone 6 pixel dimensions
MAX_HEIGHT="${MAX_HEIGHT:-$IPHONE_6_HEIGHT}"

[ -n "$VIDEO_URLS_FILE" ] || die

IFS=$'\n' read -d '' -r -a urls < "${VIDEO_URLS_FILE}" 
mkdir -p resized_videos

echo "About to download and resize ${#urls[*]} videos"
for ((i=0; i<${#urls[*]}; i++))
do
    video_url="${urls[i]}"
    echo
    echo "======================================================"
    echo "Downloading and resizing video $((i+1))/${#urls[*]}..."
    echo "======================================================"
    echo
    ffmpeg -i "${video_url}" -vf scale=w=${MAX_WIDTH}:h=${MAX_HEIGHT}:force_original_aspect_ratio=decrease "resized_videos/$(basename ${video_url})"
done
echo "Finished bulk download and resize."
