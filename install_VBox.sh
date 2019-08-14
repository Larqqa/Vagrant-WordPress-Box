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
The Scripts should be ran with administrator priviliges to avoid install errors
${RESET}"

while true; do
  read -p "Are you running this as Administarator? [ y / N ] " check
  case $check in
    [Yy]* ) echo "Starting the installation!" && break;;
    [Nn]* ) echo "Remember to run as admin!" && exit;;
    * ) echo "Please answer y or n";;
  esac
done

#:::::: Set some variables :::::#

# Aucor Starter Defaults
default_name="Aucor Starter"
default_id="aucor_starter"
default_url="http://localhost:8080"
default_author="Aucor Oy"
default_authorurl="https://www.aucor.fi"

echo "Set your MySQL database Password"
read password

echo "Set the name of your theme. (Default: $default_name)"
read name

# use default if empty
if test -n "$name"; then
  echo ""
else
  name=$default_name
fi

echo "Set the id of your theme. (Default: $default_id)"
read id

# use default if empty
if test -n "$id"; then
  echo ""
else
  id=$default_id
fi

echo "Set the dev url of your theme. (Default: $default_url)"
read url

# use default if empty
if test -n "$url"; then
  echo ""
else
  url=$default_url
fi

echo "Set the author of your theme. (Default: $default_author)"
read author

# use default if empty
if test -n "$author"; then
  echo ""
else
  author=$default_author
fi

echo "Set the url of your author. (Default: $default_authorurl)"
read authorurl

# use default if empty
if test -n "$authorurl"; then
  echo ""
else
  authorurl=$default_authorurl
fi

while true; do
read -p "Is this correct?
MySQL password: $password
Themename: $name
ID: $id
URL: $url
Author: $author
Author URL: $authorurl
Proceed to install? [y/N]
" yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer y or n.";;
  esac
done

# Set Exports
export DBPASSWD=$password
export THEMENAME=$name
export id=$id
export URL=$url
export AUTHOR=$author
export AUTHOR_URL=$authorurl

# Destroy the old Box
vagrant destroy << END
y
END

# Remove data folder
rm -rf data

clear

# Run Vagrant Box
vagrant up