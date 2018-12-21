#!/bin/bash

#                                                                                #
#  Copyright (C) 2018 Wh1teRose                                                  #
#                                                                                #
#  Game Server AIO Installer is free software; you can redistribute it and/or    #
#  modify it under the terms of the GNU Lesser General  Public License           #
#  as published by the Free Software Foundation, either version 3                #
#  of the License, or (at your option) any later version.                        #
#                                                                                #
#  Game Server AIO Installer is distributed in the hope  that it will be useful  #
#  but WITHOUT ANY WARRANTY; without even the implied  warranty of               #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the  GNU Lesser      #
#  General Public License for more details.                                      #
#                                                                                #
#  You should have received a copy of the GNU Lesser General Public License      #
#  along with this program. If not, see http://www.gnu.org/licenses/.            #
#                                                                                #
#  Website: https://snthtk.darktech.org                                          #
#                                                                                #
# PSST! I love you! <3                                                           #

#                   #
### Colors & Vars ###
#                   #

RED='\e[1;31m'
GRE='\e[1;32m'
CYN='\e[1;36m'
NC='\033[0m' # No Color                                                                              #


#                           #
### CSGO Plugin selection ###
#                           #

options=(
         "SurfTimer - 2.02 - Core of this server."
         "AutoFileLoader - Caches all material, model, and sound files for players to download."
         "Chat-Procesor - Chat Processing Plugin"
         "Dynamic - PreReq for many plugins to work properly."
         "FixAngles - Fixes 'wrong angle on material' error that gets spammed in console when using store items"
         "Mapchooser_Extended - Map Vote System. See maplist.cfg/mapcycle.cfg."
         "MOTDF - Fixes MOTD messages"
         "RampSlopeFix - Smooths out ramps and prevents clipping with player models. (Eg. no more sudden stopping when surfing)"
         "Updater - Automatically updates plugins. ONLY WORKS ON PLUGINS THAT HAVE BUILTIN SUPPORT!"
         "CallAdmin - Allows players to report players in game to your Discord/TS server. Requires Discord_API"
         "GunMenu 1.2 - Adds a gun selection menu for players to pick a weapon to surf with"
         "Hex-Tags - Tag/Color system for Chat and Scoreboard"
         "Movement-Unlocker - Unlocks max speed allowing higher surf speeds"
         "ServerAdvertisements - Used to greet joining players and post information via chat box"
         "Skinchooser-4.9 - Used to allow players to equip models (aka skins for their player model)"
         "Zeph-Store-1.2 - Allows players to purchase pets, hats, masks, etc. This requires a FastDL!"
         "TooLateToBan - Allows Admins to ban users after they have left the server via Admin Menu")
 
menu() {
    clear
    echo -e "${CYN}Pick your Plugins:${NC}\n"
    for i in ${!options[@]}; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
}
prompt="Check an option (again to uncheck, ENTER when done): "

[[ "$num" =~ "-" ]] && num=$(seq $(sed -E 's/(\d*)-(\d*)/\1 \2/' <<<"$num")) # Allow number Range 
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
  for i in $num; do
    ((i--))
    [[ "${choices[i]}" ]] && choices[i]="" || choices[i]="*"
  done
done

for i in ${!options[@]}; do
    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}";}
done

if [ ${options} = 1] then  ## 2 brackets needed? check for errors
  echo -ne "Choice 1 was selected"
fi
#                                           #
### (Whiptail Menu) CSGO Plugin selection ###
#                                           #

: '             
if [[ "$opt" = "CSGO-SURF" ]]; then
  plugins=$(whiptail --title "Test Checklist Dialog" --radiolist \
  "Choose your plugins" 25 140 18 \
  "SurfTimer - 2.02"    "Core of this server." ON \
  "AutoFileLoader"      "Caches all material, model, and sound files for players to download." ON \
  "Chat-Procesor"       "Chat Processing Plugin" on \
  "Dynamic"         "PreReq for many plugins to work properly." on \
  "FixAngles"       "Fixes wrong angle on material error that gets spammed in console when using store items" on \
  "Mapchooser_Extended"   "Map Vote System. See maplist.cfg/mapcycle.cfg." on \
  "MOTDF"         "Fixes MOTD messages" on \
  "RampSlopeFix"      "Smooths out ramps and prevents clipping with player models. (Eg. no more sudden stopping when surfing)" on \
  "Updater"         "Automatically updates plugins. ONLY WORKS ON PLUGINS THAT HAVE BUILTIN SUPPORT!" on \
  "CallAdmin"       "Allows players to report players in game to your Discord/TS server. Requires Discord_API" off \
  "GunMenu 1.2"     "Adds a gun selection menu for players to pick a weapon to surf with" off \
  "Hex-Tags"        "Tag/Color system for Chat and Scoreboard" off \
  "Movement-Unlocker"   "Unlocks max speed allowing higher surf speeds" off \
  "ServerAdvertisements"  "Used to greet joining players and post information via chat box" off \
  "Skinchooser-4.9"     "Used to allow players to equip models (aka skins for their player model)" off \
  "Zeph-Store-1.2"    "Allows players to purchase pets, hats, masks, etc. This requires a FastDL!" off \
  "TooLateToBan"      "Allows Admins to ban users after they have left the server via Admin Menu" off 3>&1 1>&2 2>&3)
fi
'

#                                     #
### Plugin/Config Custom Installion ###
#                                     #










exit
