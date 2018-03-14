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

#                   #
### Check distrib ###
#                   #

if ! [ -x "$(command -v aptitude)" ]; then
  echo -ne "${RED}Error: Distro not supported.${NC}"'\n' >&2
  exit 1;
fi

#                 #
###  Check root ###
#                 #

if [ "$(id -u)" -ne 0 ]; then 
  echo -ne "${RED}Ur not Root bro! Run with sudo :)${NC}"'\n'; 
  exit 1; 
fi

#                      #
### Server Type Menu ###
#                      #

PS3='Please select your server type:'
options=("CSGO-SURF" "CSGO-Retakes" "CSGO-Arena" "KillingFloor2" "Quit")
select opt in "${options[@]}"; 
do 
     case "$opt" in
       "CSGO-SURF")
            server_type="Surf";
            echo "you chose Surf" ;
            break ;;
       "CSGO-Retakes")
            server_type="Retakes";
            echo "you chose Retakes" ;
            break ;;
       "CSGO-Arena")
            server_type="Arena";
            echo "you chose Arena" ;
            break ;;
        "KillingFloor2")
            server_type="KF2";
            echo "you chose KF2" ;
            break ;;
       "Quit")
            break ;;
       *) echo invalid option ;;
    esac
done

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

if [[ ${options} = 1]] then 
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
  "FixAngles"       "Fixes 'wrong angle on material error' that gets spammed in console when using store items" on \
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

#                             #
### Required Packages Check ###
#                             #

if [ "$opt" != "KillingFloor2" ]; then
  echo "Adding i386 architecture..."
  dpkg --add-architecture i386 >/dev/null
  if [ "$?" -ne "0" ]; then
    echo "ERROR: Cannot add i386 architecture..."
    exit 1
  fi
fi

echo "Installing required packages..."
aptitude update >/dev/null
aptitude install -y -q libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 curl gdb screen tar wget >/dev/null
if [ "$?" -ne "0" ]; then
  echo "ERROR: Cannot install required packages..."
  exit 1
fi

#                   #
### DL Base Files ###
#                   #

echo "Running Base System Download Script...";
server_dir="$HOME/$server_type";

cd $HOME;
echo -ne "${RED}Deleting steamcmd & $server_type directories if they exist...${NC}" && sleep 2;
rm -rf ~/steamcmd; 
rm -rf ~/$server_type;
echo -ne "${GREEN}Downloading & Installing SteamCmd...${NC}" && sleep 2;
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz;
mkdir ~/steamcmd;
tar -xvzf steamcmd_linux.tar.gz -C steamcmd;
rm steamcmd_linux.tar.gz*;
cd ~/steamcmd;
# download srcds for csgo (740)
./steamcmd.sh +login anonymous +force_install_dir $server_dir +app_update 740 validate +quit;

if [[ "$opt" = "Surf" ]]; then
  echo -ne "Surf Server Install starting";
  server_dir="$HOME/Retakes/csgo"
  configs="$HOME/github/Surf/addons/sourcemod/configs/"
  cd_dir="eval cd "$HOME/github/Surf/csgo/""
fi

if [[ "$opt" = "Retakes" ]]; then
  echo -ne "Retakes Server Install starting";
  server_dir="$HOME/Retakes/csgo"
  configs="$HOME/github/Retakes/addons/sourcemod/configs/"
  cd_dir="eval cd "$HOME/github/Retakes/csgo/""
fi

if [[ "$opt" = "Arena" ]]; then
  echo -ne "Arena Server Install starting";
  mkdir $HOME/Arena/csgo
  server_dir="$HOME/Arena/csgo"
  configs="$HOME/github/Arena/addons/sourcemod/configs/"
  cd_dir="eval cd "$HOME/github/Arena/csgo/""
fi

  echo -ne "${RED}Removing Existing Addons Directory if Applicable. If You Don't Have an installed server to Surf, then this will Do nothing and is safe. Script will continue in 10 Secs...${NC}" && sleep 10
  rm -rf $server_dir/addons

  # make addons folder
  test -e $server_dir/addons || mkdir $server_dir/addons

  # metamod
  echo -ne "${GREEN}Installing Metamod...${NC}" && sleep 2
  for dest in $server_dir/addons
  do
  cp -rf $HOME/github/$server_dir/addons/metamod $dest
  cp -rf $HOME/github/$server_dir/addons/metamod.vdf $dest
  done 

  # sourcemod
  echo -ne "${GREEN}Downloading & Installing Sourcemod...${NC}" && sleep 2
  url=$(curl -s https://sm.alliedmods.net/smdrop/1.8/sourcemod-latest-linux)
  wget "https://sm.alliedmods.net/smdrop/1.8/$url"
  tar -xvzf "${url##*/}" -C $server_dir

  # Stripper Files
  echo -ne "${GREEN}Installing Stripper Files...${NC}" && sleep 2
  for dest in $server_dir/addons/
  do
  cp -rf $HOME/github/$server_dir/addons/stripper $dest
  done

  echo -ne "${GREEN}Copying Over Pre-Configured SourceMod Config & Plugins...${NC}" && sleep 2
  for dest in $server_dir/addons/
  do
  cp -rf $HOME/github/$server_dir/addons/sourcemod $dest
  done

  echo -ne "${GREEN}Copying Over Pre-Configured Config Files...${NC}" && sleep 2
  # cfg files
  rm -rf "$configs\database.cfg" "$configs\admins.cfg" "$configs\admin_groups.cfg"
  for dest in $server_dir/cfg/
  do
  cp -rf $HOME/github/$server_dir/cfg/sourcemod $dest
  cp -rf $HOME/github/$server_dir/cfg/* $dest
  done

  # map files
  echo -ne "${GREEN}Installing Map Files...${NC}" && sleep 2
  wget -0 $server_dir/maps.tar.bz2 "http://www.snthtk.darktech.org/forum/sharedfiles/maps.tar.bz2"
  for dest in $server_dir/
  do
  find $server_dir/maps -maxdepth 1 -type f -delete
  cp -f $HOME/github/$server_dir/scripts/maps.tar.bz2 $dest
  done

  for dest in $server_dir
  do
  cp -rf $HOME/github/$server_dir/maplist.txt $dest
  cp -rf $HOME/github/$server_dir/cfg/mapcycle.txt $dest
  done

  #Extract maps.tar.bz2
  tar -xvjf $server_dir/maps.tar.bz2 -C $server_dir/csgo && rm -f && rm '$server_dir/maps.tar.bz2' -f

  # extract individual maps and nav files
  echo -ne "${RED}Still Installing Map Files Please Be Patient...${NC}" && sleep 5
  for i in $server_dir/maps/*.bsp.bz2; do 
      bzip2 -d "$i"
  done

  for i in $server_dir/maps/*.nav.bz2; do 
      bzip2 -d "$i"
  done

  # Copy start script and start server
  echo -ne "${GREEN}Copying Over Start Script and Starting Server...${NC}" && sleep 5
  for dest in $HOME/Surf
  do
  cp -rf $HOME/github/$server_dir/scripts/start.sh $dest && cd $dest && sh start.sh
  done


if [ $opt != "KillingFloor2" ]; then
  echo "Adding i386 architecture..."
  dpkg --add-architecture i386 >/dev/null
  if [ "$?" -ne "0" ]; then
    echo "ERROR: Cannot add i386 architecture..."
    exit 1
  fi
fi


if [[ "$opt" = "KF2" ]]; then
  echo -ne "blah blah";
fi