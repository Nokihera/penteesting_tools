#!/bin/bash
dl_path="/home/touchme/Downloads"
cat << "EOF"
 ___,___,_______,____
|  :::|///./||'||    \
|  :::|//.//|| || H)  |
|  :::|/.///|!!!|     |
|   _______________   |
|  |:::::::::::::::|  |
|  |_______________|  |
|  |_______________|  |
|  |_______________|  |
|  |_______________|  |
||_|    touchme    ||_|
|__|_______________|__|

EOF

echo "***** File sorting process is starting now !! *****"
mv $dl_path/*.jpg /home/touchme/Pictures 2>/dev/null
mv $dl_path/*.png /home/touchme/Pictures 2>/dev/null
echo -ne '#####                     (33%)\r'
sleep 0.05
mv $dl_path/*.pdf /home/touchme/Documents 2>/dev/null
mv $dl_path/*.mp4 /home/touchme/Videos 2>/dev/null
mv $dl_path/*.txt /home/touchme/Documents 2>/dev/null
echo -ne '#############             (66%)\r'
sleep 0.05
mv $dl_path/*.mp3 /home/touchme/Music 2>/dev/null
mv $dl_path/*.flac /home/touchme/Music 2>/dev/null
echo -ne '#######################   (100%)\r'
echo -ne '\n'
echo "***** File sorting process has finished !! *****"
notify-send "SortMe" "Sorting completed!" --icon=folder-download
