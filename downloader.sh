#!/bin/bash
cat << EOF
 ___________________
 | _______________ |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 |_________________|
     _[_______]_
 ___[___________]___
|         [_____] []|__
|         [_____] []|  \__
L___________________J     \ \___\/
 ___________________      /\
/###################\    (__)

EOF
video_path="/home/touchme/Videos/"
echo "***** Movie Downloader *****"
echo "Please paste your movie download link:"
read url
echo "Please type the name of the video:"
read name
wget -c "$url" -O "$video_path$name.mp4" --show-progress
notify-send "Downloader" "Download finished: $name" --icon=video-x-generic
