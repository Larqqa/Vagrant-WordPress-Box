#! /usr/bin/env bash
clear

BOLD=$(tput bold)
GREEN=$(tput setaf 2)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

echo "${WHITE}
                   wwwwwwwwwwwwwwwwwwwwww
               wwwwwwwww            wwwwwwwww
            wwwwww   wwwwwwwwwwwwwwwwww   wwwwww
          wwww   wwwwwwwwwwwwwwwwwwwwwwwwww   wwww
        wwww  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww  wwww
      wwww  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww   wwww
    wwww  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww        wwww
   www  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww           www
  www          wwwwwwwwww         wwwwwwwww            www
 www  w       wwwwwwwwwwww       wwwwwwwwwww        ww  www
 ww  www       wwwwwwwwwwww       wwwwwwwwwwww      www  ww
www  www       wwwwwwwwwwwww       wwwwwwwwwwww     www  www
ww  wwwww       wwwwwwwwwwww       wwwwwwwwwwww     wwww  ww
ww  wwwwww       wwwwwwwwwwww       wwwwwwwwwwww   wwwww  ww
ww  wwwwwww      wwwwwwwwwwwww       wwwwwwwwwww  wwwwww  ww
ww  wwwwwww       wwwwwwwwwww        wwwwwwwwwww  wwwwww  ww
ww  wwwwwwww       wwwwwwwww  w       wwwwwwwww  wwwwwww  ww
ww  wwwwwwwww      wwwwwwwww www       wwwwwwww wwwwwwww  ww
www  wwwwwwww       wwwwwww wwwww      wwwwwww  wwwwwww  www
 ww  wwwwwwwww       wwwww  wwwwww      wwwww  wwwwwwww  ww
 www  wwwwwwwww      wwwww wwwwwww       wwww wwwwwwww  www
  www  wwwwwwwww      www wwwwwwwww      www  wwwwwww  www
   www  wwwwwwww       w wwwwwwwwwww      ww wwwwwww  www
    wwww  wwwwwww        wwwwwwwwwww        wwwwww  wwww
      wwww  wwwwww      wwwwwwwwwwwww      wwwww  wwww
        wwww  wwwww    wwwwwwwwwwwwwww     www  wwww
          wwww   ww    wwwwwwwwwwwwwwww       wwww
            wwwwww    wwwwwwwwwwwwwwwww   wwwwww
               wwwwwwwww            wwwwwwwww
                   wwwwwwwwwwwwwwwwwwwwww
${RESET}"
echo "${BOLD}${GREEN}
                    Vagrant WordPress Box
${RESET}"

echo "${WHITE}
You are about to install a Vagrant Box for running WordPress.
${RESET}"

# Make sure user is running shell as administrator
echo "${BOLD}
The Scripts require administrator priviliges
${RESET}"

while true; do
  read -p "Are you running this as Administarator? [ y / N ] " check
  case $check in
    [Yy]* ) echo "Continuing with the installation!" && break;;
    [Nn]* ) echo "Remember to run as admin!" && exit;;
    * ) echo "Please answer y or n";;
  esac
done

# Destroy the old Box
vagrant destroy << END
y
END

# Remove data folder
rm -rf data

clear

# Run Vagrant Box
vagrant up