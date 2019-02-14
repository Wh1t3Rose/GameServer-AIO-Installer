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
NC='\033[0m' # No Color

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
./steamcmd.sh +login anonymous +force_install_dir $server_dir +app_update $mod_id validate +quit;

exit