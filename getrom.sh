#!/bin/sh
# This file goes to /.tmp_update/script

sysdir="/mnt/SDCARD/.tmp_update"
# sysdir="../"
scriptdir="${sysdir}/script"
romsdir="/mnt/SDCARD/Roms"
workdir="/tmp"
full_page=${workdir}/mmprd_full_page_
rom_names_file=${workdir}/mmprd_rom_names.txt
orig_rom_names_file=${workdir}/mmprd_orig_rom_names.txt

PS_EUR_SOURCE='https://archive.org/download/chd_psx_eur/CHD-PSX-EUR/   chd'
PS_USA_SOURCE='https://archive.org/download/chd_psx/CHD-PSX-USA/       chd'
GB_SOURCE='https://archive.org/download/nointro.gb/                    7z'
GBC_SOURCE='https://archive.org/download/nointro.gbc-1/                7z'
GBA_SOURCE='https://archive.org/download/nointro.gba/                  7z'
MD_SOURCE='https://archive.org/download/nointro.md/                    7z'
FC_SOURCE='https://archive.org/download/nointro.nes/                   7z'
SFC_SOURCE='https://archive.org/download/nointro.snes/                 7z'

PATH="$sysdir/bin:$PATH"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$sysdir/lib:$sysdir/lib/parasyte"


bline="                    <Menu>: Exit        <A>: Select"
echo_cmd="echo -e"
# echo_cmd="echo"


decode_url()
{
    local url_encoded=$(cat)
    # Replace %20 with space
    url_decoded=$(echo "$url_encoded" | sed 's/%20/ /g')
    # Add more replacements if needed
    url_decoded=$(echo "$url_decoded" | sed 's/%21/!/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%22/"/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%23/#/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%24/\$/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%25/%/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%26/\&/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%27/'\''/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%28/(/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%29/)/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%2A/*/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%2B/+/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%2C/,/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%2D/-/g')
    url_decoded=$(echo "$url_decoded" | sed 's/%2E/./g')
    url_decoded=$(echo "$url_decoded" | sed 's/%2F/\//g')
    # Add more replacements as necessary
    echo "$url_decoded"
}


print_progress()
{
    while kill -0 "$wget_pid" 2> /dev/null; do
        echo -n "."
        sleep 1
    done
}


rom_menu()
{
    mode="$1"
    rom_name_ptrn="$2"

    while true; do
        clear; echo "Working..."

        page="${full_page}${EMU}"
        base_url="${SRC%% *}"
        ext="${SRC##* }"

        if [ "${mode}" = "search" ]; then
            clear
            echo -ne "\e[?25h"  # cursor
            ${echo_cmd} "<X>: Keyboard\n<A>: Keypress\n<L1>: Shift\n<R1>: Backspace\n<L2>: Left\n<R2>: Right\n<Start>: Enter\n\n"
            readline -m "Search $EMU ROMs by grep pattern: "
            rom_name_ptrn=$( cat /tmp/readline.txt )
            [ "${rom_name_ptrn}" = "" ] && return
        fi

        if ! [ -f ${page} ] || ! [ -s ${page} ]; then
            wget -q -O - "${base_url}" | tee ${page} > /dev/null &
            wget_pid=$!
            clear
            echo "Downloading list of ${EMU} .${ext} ROM files from"
            echo "${base_url}"
            print_progress
        fi

        rom_names=$( cat ${page} | \
                     grep -oE 'href="[^\"]*\.'${ext}'"' | \
                     sed 's/href="//' | \
                     sed 's/"//' | \
                     tee ${orig_rom_names_file} | \
                     decode_url | \
                     tee ${rom_names_file} )

        [ "${rom_name_ptrn}" != "" ] && rom_names=$( grep ${rom_name_ptrn} ${rom_names_file} )

        if [ -z "${rom_names}" ]; then
            echo
            echo "No ${EMU} roms found matching pattern: '${rom_name_ptrn}'"
            mode="search"
            sleep 3
            continue
        fi

        pick=$( ${echo_cmd} "<Search>\n<Reload>\n<Back>\n${rom_names}\n\n" | \
                ${scriptdir}/shellect.sh -b "${bline}" -t "       [ Matching $EMU ROMS ] " )

        clear
        [ "$pick" = "<Back>" ] && return
        [ "$pick" = "<Search>" ] && mode="search" && continue
        [ "$pick" = "<Reload>" ] && mode="search result" && rm -f ${page} && continue

        rom_name=$( sed -n "$( grep -n "$pick" ${rom_names_file} | cut -d: -f1){p;q}" ${orig_rom_names_file} )
        rom_dir="${romsdir}/$EMU"

        clear
        echo "Download '$pick' to '$rom_dir'"
        echo
        if ! wget -O "$pick" -P "$rom_dir/" "${base_url}$rom_name"; then
            echo "Download failed."
        fi

        sleep 3

        # rm -f ${rom_names_file} ${orig_rom_names_file}
        if [ -f "${scriptdir}/reset_list.sh" ]; then
            "${scriptdir}/reset_list.sh" "${romsdir}/${EMU}" >/dev/null 2>&1
        fi

        mode="search result"
    done
}


emu_menu()
{
    clear
    emus="<Back>\nPS\nGB\nGBC\nGBA\nFC\nSFC\nMD\n\n"
    pick=$( ${echo_cmd} "$emus" | \
            ${scriptdir}/shellect.sh -b "${bline}" -t "           [ Emulator Menu ] " )
    [ "$pick" = "<Back>" ] && return
    EMU=$pick
}


main_menu()
{
    while true; do
        clear

        [ "$EMU" = "PS" ] && SRC=$PS_EUR_SOURCE
        [ "$EMU" = "GB" ] && SRC=$GB_SOURCE
        [ "$EMU" = "GBC" ] && SRC=$GBC_SOURCE
        [ "$EMU" = "GBA" ] && SRC=$GBA_SOURCE
        [ "$EMU" = "MD" ] && SRC=$MD_SOURCE
        [ "$EMU" = "FC" ] && SRC=$FC_SOURCE
        [ "$EMU" = "SFC" ] && SRC=$SFC_SOURCE


        opt1="${SRC:+"Browse ${EMU} .${SRC##* } ROMs at $(basename ${SRC%% *})"}"
        opt2="${SRC:+"Search ${EMU} .${SRC##* } ROM at $(basename  ${SRC%% *})"}"
        opt3="${SRC:+"Clear ${EMU} romdir cache"}"
        opt4="Select ${SRC:+another }emulator"
        opt5="<Exit>"

        # clear
        pick=$( ${echo_cmd} "$opt1\n$opt2\n\n$opt3\n$opt4\n$opt5\n\n" | \
                ${scriptdir}/shellect.sh -b "${bline}" -t "              [ MAIN MENU ] " )

        [ "$pick" = "$opt1" ] && rom_menu "browse" && continue
        [ "$pick" = "$opt2" ] && rom_menu "search" && continue
        [ "$pick" = "$opt3" ] && ${scriptdir}/reset_list.sh "${romsdir}/${EMU}" && echo "${EMU} romdir cache cleared." && sleep 3 && continue
        [ "$pick" = "$opt4" ] && emu_menu && continue
        [ "$pick" = "$opt5" ] && exit

    done
}


EMU="$1"

main_menu