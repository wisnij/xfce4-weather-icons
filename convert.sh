#!/bin/bash

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

convert_icon () {
    icon=$1
    icon_src="svg/$icon.svg"
    if [[ ! -e $icon_src ]]; then
        return
    fi

    for size in ${sizes[@]}; do
        size_src="svg/$icon.$size.svg"
        if [[ ! -e $size_src ]]; then
            size_src=$icon_src
        fi

        dest="$size/$icon.png"
        echo "$size_src -> $dest"
        convert -size "${size}x${size}" -background none "$size_src" "$dest"
    done
}

for weather in ${weathers[@]}; do
    convert_icon "$weather"
    convert_icon "$weather-night"
done
