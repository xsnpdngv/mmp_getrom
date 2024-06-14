# MMP Get ROM

This is a context-aware romscript to download game roms from archive.org for the Miyoo Mini Plus retro game console with Onion OS on it.


## Operation

On Game List Options (green button when in game list of an emulator) select 'Get rom for _emulator_'.
The script will then offer the available operations for the actual emulator the game list of which
you are in, to Browse or Search available game roms on archive.org for the pre-configured rom-set page.


## Customization

Feel free to modify the URLs of the game rom source pages for any emulator in `getrom.sh`.

```sh
# <source name>='<archive.org rom-set page URL>                        <rom extension on the page>'
PS_EUR_SOURCE='https://archive.org/download/chd_psx_eur/CHD-PSX-EUR/   chd'
PS_USA_SOURCE='https://archive.org/download/chd_psx/CHD-PSX-USA/       chd'
GB_SOURCE='https://archive.org/download/nointro.gb/                    7z'
GBC_SOURCE='https://archive.org/download/nointro.gbc-1/                7z'
GBA_SOURCE='https://archive.org/download/nointro.gba/                  7z'
MD_SOURCE='https://archive.org/download/nointro.md/                    7z'
FC_SOURCE='https://archive.org/download/nointro.nes/                   7z'
SFC_SOURCE='https://archive.org/download/nointro.snes/                 7z'
```

## Install

- Put `Get_ROM.sh` to `/App/romscripts`
- Put `getrom.sh` to `/.tmp_update/script`
