#!/bin/sh
# This file goes to /App/romscripts
scriptlabel="Get %LIST% rom"
require_networking=1
echo $0 $*

sysdir=/mnt/SDCARD/.tmp_update

pressMenu2Kill st &

cd $sysdir
./bin/st -q -e "$sysdir/script/getrom.sh" "$(basename $2)"

pkill -9 pressMenu2Kill
