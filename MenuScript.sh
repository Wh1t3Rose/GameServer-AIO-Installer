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
#                                                                                #

# Check distrib
if ! [ -x "$(command -v aptitude)" ]; then
  echo -e "{$RED}Error: Distro not supported.${NC}" >&2
  exit 1
fi

# Check root
if [ $(id -u) -ne 0 ]; then 
  echo -e "{$RED}Ur not Root bro${NC}"; 
  exit 1; 
fi

# Vars
#...

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

PS3='Please select your server type:'
options=("CSGO-SURF" "CSGO-Retakes" "CSGO-Arena" "KillingFloor2")
select opt in "${options[@]}" "Quit"; do 
     case "$opt" in
       "CSGO-SURF")
            server_type="Surf";
            echo "you chose Surf" ;;
       "CSGO-Retakes")
            server_type = "Retakes";
            echo "you chose Retakes" ;;
       "CSGO-Arena")
            server_type = "Arena";
            echo "you chose Arena" ;;
        "KillingFloor2")
            server_type = "KF2";
            echo "you chose KF2" ;;
       "Quit")
            break ;;
       *) echo invalid option ;;
    esac
if [ $opt != "KillingFloor2" ]; then
  echo "Adding i386 architecture..."
  dpkg --add-architecture i386 >/dev/null
  if [ "$?" -ne "0" ]; then
    echo "ERROR: Cannot add i386 architecture..."
    exit 1
  fi

echo "Installing required packages..."
aptitude update >/dev/null
aptitude install -y -q libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 curl gdb screen tar wget >/dev/null
if [ "$?" -ne "0" ]; then
  echo "ERROR: Cannot install required packages..."
  exit 1
fi
  # Dowload Base Files
  echo "Running Base System Download Script...";
    server_dir="$HOME/$server_type";

    cd $HOME;
    echo -e "${RED}Deleting steamcmd & $server_type directories if they exist...${NC}" && sleep 2;
    rm -rf ~/steamcmd; 
    rm -rf ~/$server_type;
    echo -e "${GREEN}Downloading & Installing SteamCmd...${NC}" && sleep 2;
    wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz;
    mkdir ~/steamcmd;
    tar -xvzf steamcmd_linux.tar.gz -C steamcmd;
    rm steamcmd_linux.tar.gz*;
    cd ~/steamcmd;
    # download srcds for csgo (740)
  ./steamcmd.sh +login anonymous +force_install_dir $server_type +app_update 740 validate +quit;
fi
done

if [[ $opt="Surf"} ]]; then
  echo -e "Surf Server Install starting";
  server_dir="$HOME/csgo_surf/csgo"
  configs="$HOME/github/$server_dir/csgo/addons/sourcemod/configs/"
  cd_dir="eval cd "$HOME/github/$server_dir/csgo/""

  echo -e "${RED}Removing Existing Addons Directory if Applicable. If You Don't Have an installed server to csgo_surf, then this will Do nothing and is safe. Script will continue in 10 Secs...${NC}" && sleep 10
  rm -rf $server_dir/addons

  # make addons folder
  test -e $server_dir/addons || mkdir $server_dir/addons

  # metamod
  echo -e "${GREEN}Installing Metamod...${NC}" && sleep 2
  for dest in $server_dir/addons
  do
  cp -rf $HOME/githu b/$server_dir/csgo/addons/metamod $dest
  cp -rf $HOME/github/$server_dir/csgo/addons/metamod.vdf $dest
  done 

  # sourcemod
  echo -e "${GREEN}Downloading & Installing Sourcemod...${NC}" && sleep 2
  url=$(curl -s https://sm.alliedmods.net/smdrop/1.8/sourcemod-latest-linux)
  wget "https://sm.alliedmods.net/smdrop/1.8/$url"
  tar -xvzf "${url##*/}" -C $server_dir

  # Stripper Files
  echo -e "${GREEN}Installing Stripper Files...${NC}" && sleep 2
  for dest in $server_dir/addons/
  do
  cp -rf $HOME/github/$server_dir/csgo/addons/stripper $dest
  done

  echo -e "${GREEN}Copying Over Pre-Configured SourceMod Config & Plugins...${NC}" && sleep 2
  for dest in $server_dir/addons/
  do
  cp -rf $HOME/github/$server_dir/csgo/addons/sourcemod $dest
  done

  echo -e "${GREEN}Copying Over Pre-Configured Config Files...${NC}" && sleep 2
  # cfg files
  rm -rf "$configs\database.cfg" "$configs\admins.cfg" "$configs\admin_groups.cfg"
  for dest in $server_dir/cfg/
  do
  cp -rf $HOME/github/$server_dir/csgo/cfg/sourcemod $dest
  cp -rf $HOME/github/$server_dir/csgo/cfg/* $dest
  done

  # map files
  echo -e "${GREEN}Installing Map Files...${NC}" && sleep 2
  wget -0 $server_dir/maps.tar.bz2 "http://www.snthtk.darktech.org/forum/sharedfiles/maps.tar.bz2"
  for dest in $server_dir/
  do
  find $server_dir/maps -maxdepth 1 -type f -delete
  cp -f $HOME/github/$server_dir/scripts/maps.tar.bz2 $dest
  done

  for dest in $server_dir
  do
  cp -rf $HOME/github/$server_dir/csgo/maplist.txt $dest
  cp -rf $HOME/github/$server_dir/csgo/cfg/mapcycle.txt $dest
  done

  #Extract maps.tar.bz2
  tar -xvjf $server_dir/maps.tar.bz2 -C $server_dir/csgo && rm -f && rm '$server_dir/maps.tar.bz2' -f

  # extract individual maps and nav files
  echo -e "${RED}Still Installing Map Files Please Be Patient...${NC}" && sleep 5
  for i in $server_dir/maps/*.bsp.bz2; do 
      bzip2 -d "$i"
  done

  for i in $server_dir/maps/*.nav.bz2; do 
      bzip2 -d "$i"
  done

  # Copy start script and start server
  echo -e "${GREEN}Copying Over Start Script and Starting Server...${NC}" && sleep 5
  for dest in $HOME/csgo_surf
  do
  cp -rf $HOME/github/$server_dir/scripts/start.sh $dest && cd $dest && sh start.sh
  done
fi
done

if [[ $opt="Retakes" ]]; then
  echo -e "Retakes Server Install starting";

fi
done

if [[ $opt="Arena" ]]; then
  echo -e "blah";
fi
done

if [[ $opt="KF2" ]]; then
  echo -e "blah blah";
fi
done
