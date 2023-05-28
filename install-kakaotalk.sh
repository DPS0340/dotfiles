#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

LOCATION=$(realpath "$0")
DIR=$(dirname "$LOCATION")

cd ~/Downloads

wget https://github.com/carpedm20/UNIST-robot/raw/master/Resources/malgun.ttf
mkdir -p ~/.wine/drive_c/windows/Fonts
mv malgun.ttf ~/.wine/drive_c/windows/Fonts

wget https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe

cat ~/.wine/system.reg \
	| sed 's/"MS Shell Dlg"="Tahoma"/"MS Shell Dig"="Malgun Gothic"/g' \
	| sed 's/"MS Shell Dlg 2"="Tahoma"/"MS Shell Dig 2"="Malgun Gothic"/g' \
	| sudo tee ~/.wine/system.reg

wine KakaoTalk_Setup.exe
