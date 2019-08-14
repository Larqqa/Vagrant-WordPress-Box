# WordPress Box using Aucor Starter theme
[Aucor Starter theme](https://github.com/aucor/aucor-starter/tree/master)

To install or reinstall the Box, run:
```
sh install.sh
```
Running the script again after installation destroys the box automatically.

## What
This is a Vagrant box for installing a simple LAMP stack & WordPress. The WordPress runs the Aucor Starter theme as a default theme. Also the plugins Aucor Core, Yoast SEO, Advanced Custom Fields & Redirection are installed by default. The box uses NodeJS 10.x & Yarn to run the packages used in the theme.
## Why
I wanted get to know Vagrant better and automate the WordPress installation process. This allows me to get a totally new WordPress development environment up and running in a couple minutes.
## How
Using Vagrant to ease the use of VirtualBox. Using bash scripts to install everything and automate the installation of WordPress for faster development and deployment. WordPress is installed using WP-CLI.

On Windows there is some problems with symlinks & VirtualBoxes. You need to install the theme packages with --no-bin-links and install Gulp as global to allow the use of:
```
gulp watch
```