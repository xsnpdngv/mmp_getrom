# MMP Get ROM

This is a context-aware romscript to download game roms from archive.org for the Miyoo Mini Plus retro game console with Onion OS on it.


## Operation

In Game List Options (green/Y button when in game list of an emulator) select 'Get rom for _emulator_'.
The script will then offer, for the actual emulator the game list of which you are in, to Browse or
Search available game roms on archive.org for the pre-configured rom-set page.

The URLs of the applied ROM source pages are as follows:

- PS - Sony PlayStation: https://archive.org/download/chd_psx_eur/CHD-PSX-EUR/
- GB - Nintendo GameBoy: https://archive.org/download/nointro.gb/
- GBC - Nintendo GameBoy Color: https://archive.org/download/nointro.gbc-1/
- GBA - Nintendo GameBoy Advance: https://archive.org/download/nointro.gba/
- NES - Nintendo Entertainment System: https://archive.org/download/nointro.nes/
- SNES - Super Nintendo Entertainment System: https://archive.org/download/nointro.snes/
- MD - Sega Genesis/Mega Drive: https://archive.org/download/nointro.md/

The URLs of the game rom source pages for any emulator in `getrom.sh` can be easily modified.


## Requirements

- Miyoo Mini Plus retro gaming console: https://www.lomiyoo.com/en/
- Onion OS: https://onionui.github.io/
- Simple Terminal application: https://onionui.github.io/docs/apps/terminal
- Connected WiFi


## Install

Extract `sdcard.zip` and copy its contents right to the root of the SD card. It won't overwrite
anything, just copies the shell scripts into their desired location:

- `Get_ROM.sh` to `/App/romscripts`
- `getrom.sh` to `/.tmp_update/script`
