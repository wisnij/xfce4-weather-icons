#!/bin/bash
set -eu
cd "$(dirname "$0")"

sizes=(22 48 128)
weathers=(
    cloud
    fog
    lightcloud
    lightrain
    lightrainsun
    lightrainthunder
    lightrainthundersun
    nodata
    partlycloud
    rain
    rainthunder
    sleet
    sleetsun
    sleetsunthunder
    sleetthunder
    snow
    snowsun
    snowsunthunder
    snowthunder
    sun
)

icons=("$@")
if [[ ${#icons[@]} -eq 0 ]]; then
    for weather in ${weathers[@]}; do
        icons+=("$weather" "$weather-night")
    done
fi

convert_icon () {
    icon=$1
    icon_src="svg/$icon.svg"
    if [[ ! -e $icon_src ]]; then
        echo "$icon_src: no such file" >&2
        return 1
    fi

    for size in ${sizes[@]}; do
        size_src="svg/$icon.$size.svg"
        if [[ ! -e $size_src ]]; then
            size_src=$icon_src
        fi

        dest="$size/$icon.png"
        (
            convert -resize "${size}x${size}" -background none +set date:create +set date:modify "$size_src" "$dest"
            echo "$size_src: wrote $dest"
        ) &
    done
}

converted=0
for icon in "${icons[@]}"; do
    if convert_icon "$icon"; then
        converted=$((converted + 1))
    fi
done

wait
if [[ $converted -eq 0 ]]; then
    echo "no icons converted!" >&2
    exit 1
fi
