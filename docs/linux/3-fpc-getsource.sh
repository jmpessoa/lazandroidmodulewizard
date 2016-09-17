#!/bin/bash
# Original Author of this script: http://www.getlazarus.org
# modified by Renato Bordin - renabor 
# This is the universal Linux script to install Free Pascal and Lazarus

# If you need to fix something and or want to contribute, send your 
# changes to admin at getlazarus dot org with "linux free pascal install"
# in the subject line.

# Change the line below to define your own install folder

BASE=$HOME/bin/freepascal


# BASE can be whatever you want, but it should:
#   A) Be under your $HOME folder
#   B) Not already exist

# TODO Prompt the user for the install folder and provide BASE as the default

# The full version number of the stable compiler and the one we are building

FPC_STABLE=3.0.0
FPC_BUILD=3.0.1


# TODO Allow the user to pick their compiler and ide versions

# Prevent this script from running as root 
if [ "$(id -u)" = "0" ]; then
   echo "This script should not be run as root"
   exit 1
fi

clear
echo "Prerequisites for Free Pascal and Lazarus on Linux"
echo "--------------------------------------------------"
echo "This installer requires the following packages which"
echo "can be installed on Debian distributions by using:"
echo
echo "sudo apt-get install build-essential p7zip-full"
echo
echo "Lazarus requires the following Gtk+ dev packages which"
echo "can be installed on Debian distributions by using:"
echo
echo "sudo apt-get install libgtk2.0-dev libcairo2-dev \\" 
echo "  libpango1.0-dev libgdk-pixbuf2.0-dev libatk1.0-dev \\"
echo "  libghc-x11-dev"
echo
echo -n "Press return to check your system"
read CHOICE
echo

# function require(program) 
function require() {
	if ! type "$1" > /dev/null; then
		echo 
		echo "An error occured"
		echo 
		echo "This script requires the package $1"
		echo "It was not found on your system"
		echo 
		echo "On Debian based distributions type the following to install it"
		echo 
		echo "sudo apt-get install $2"
		echo 
		echo "Then re-run this script"
		echo 
		echo "On other distributions refer to your package manager"
		echo 
		exit 1
	fi	
	echo "$1 found"
}

# Require the following programs 
require "make" "build-essential"
require "7za" "p7zip-full"

# function requirePackage(package) 
function requirePackage() {
	INSTALLED=$(dpkg-query -W --showformat='${Status}\n' $1 2> /dev/null | grep "install ok installed")
	if [ "$INSTALLED" = "" ]; then
		echo "$1 not found"
		echo 
		echo "An error occured"
		echo 
		echo "This script requires the package $1"
		echo "It was not found on your system"
		echo 
		echo "On Debian based distributions type the following to install it"
		echo 
		echo "sudo apt-get install $1"
		echo 
		echo "Then re-run this script"
		echo 
		exit 1
	fi	
	echo "$1 found"
}

if type "dpkg-query" > /dev/null; then
	requirePackage "libgtk2.0-dev"
	requirePackage "libcairo2-dev"
	requirePackage "libpango1.0-dev"
	requirePackage "libgdk-pixbuf2.0-dev"
	requirePackage "libatk1.0-dev"
	requirePackage "libghc-x11-dev"
fi
sleep 2s

# function download(url, output)
function download() {
	if type "curl" > /dev/null; then
		curl -o "$1" "$2"
	elif type "wget" > /dev/null; then
		wget -O "$1" "$2"
	fi	
}

# Cross platform function expandPath(path)
function expandPath() {
	if [ `uname`="Darwin" ]; then
		[[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}";
	else
		echo $(readlink -m `$1`)
	fi
}

# Present a description of this script
clear
echo "Universal Linux script to install Free Pascal and Lazarus"
echo "---------------------------------------------------------"
echo "This install will download the sources for:"
echo "  Free Pascal 3.0 and Lazarus"
echo
echo "Then it will build the above for your system, which may"
echo "take a few minutes."
echo
echo "The final install will not interfere with your existing"
echo "development environment."
echo

# Ask for permission to proceed
read -r -p "Continue (y/n)? " REPLY

case $REPLY in
    [yY][eE][sS]|[yY]) 
		echo
		;;
    *)
		# Exit the script if the user does not type "y" or "Y"
		echo "done."
		echo 
		exit 1
		;;
esac


# Ask a series of questions
while true; do
	# Ask for an install location
	echo "Enter an installation folder or press return to"
	echo "accept the default install location"
	echo 
	echo -n "[$BASE]: "
		read CHOICE
	echo

	# Use BASE as the default
	if [ -z "$CHOICE" ]; then
		CHOICE=$BASE
	fi

	# Allow for relative paths
	CHOICE=`eval echo $CHOICE`
	EXPAND=`expandPath "$CHOICE"`
	EXPAND=${EXPAND%/}

	# Allow install only under your home folder
	if [[ $EXPAND == $HOME* ]]; then
		echo "The install folder will be:"
		echo "$EXPAND"
		echo
	else
		echo "The install folder must be under your personal home folder"
		echo
		continue
	fi

	# Confirm their choice
	echo -n "Continue? (y,n): "
	read CHOICE
	echo 

	case $CHOICE in
		[yY][eE][sS]|[yY]) 
			;;
		*)
			echo "done."
			echo
			exit 1
			;;
	esac

	break
done

# Ask for permission to create a local application shortcut
echo "After install do you want to shortcuts created in:"
read -r -p "$HOME/.local/share/applications (y/n)? " SHORTCUT
echo 

# Block comment for testing
: <<'COMMENT'
COMMENT

# Create the folder
BASE=$EXPAND
mkdir -p $BASE

# Exit if the folder could not be created
if [ ! -d "$BASE" ]; then
  echo "Could not create directory"
  echo
  echo "done."
  echo
  exit 1;
fi

cd $BASE

# Create our install folder
mkdir -p $BASE
cd $BASE

# Determine operating system architecture
CPU=$(uname -m)

if [ "$CPU" = "i686" ]; then
	CPU="i386"
fi
  
# Note we use our bucket instead of sourceforge or svn for the following 
# reason: 
#   It would be unethical to leach other peoples bandwidth and data
#   transfer charges. As such, we rehost the same fpc stable binary, fpc 
#   test sources, and lazarus test sources from sourceforge and free
#   pascal svn servers using our own Amazon S3 bucket.

# Download from our Amazon S3 bucket 
URL=http://cache.getlazarus.org/archives

# Download a temporary version of fpc stable
echo "Downloading fpc stable version fpc-$FPC_STABLE.$CPU-linux.7z"
download "$BASE/fpc-$FPC_STABLE.$CPU-linux.7z" $URL/fpc-$FPC_STABLE.$CPU-linux.7z
7za x "$BASE/fpc-$FPC_STABLE.$CPU-linux.7z" -o$BASE
rm "$BASE/fpc-$FPC_STABLE.$CPU-linux.7z"

# Download the new compiler source code 
echo "Downloading new compiler source $FPC_BUILD"
svn co http://svn.freepascal.org/svn/fpc/branches/fixes_3_0 $BASE/$FPC_BUILD

# Download the lazarus source code
echo "Downloading latest Lazarus source code"
download "$BASE/lazarus.7z" $URL/lazarus.7z
7za x "$BASE/lazarus.7z" "-o$BASE"
rm "$BASE/lazarus.7z"

# function replace(folder, files, before, after) 
function replace() {
	BEFORE=$(echo "$3" | sed 's/[\*\.]/\\&/g')
	BEFORE=$(echo "$BEFORE" | sed 's/\//\\\//g')
	AFTER=$(echo "$4" | sed 's/[\*\.]/\\&/g')
	AFTER=$(echo "$AFTER" | sed 's/\//\\\//g')
	find "$1" -name "$2" -exec sed -i "s/$BEFORE/$AFTER/g" {} \;
}

# Replace paths from their original location to the new one
ORIGIN="/home/boxuser/Development/Base"
replace "$BASE/lazarus/config" "*.xml" "$ORIGIN" "$BASE"
replace "$BASE/lazarus/config" "*.cfg" "$ORIGIN" "$BASE"
replace "$BASE/lazarus" "lazarus.sh" "$ORIGIN" "$BASE"
replace "$BASE/lazarus" "lazarus.desktop" "$ORIGIN" "$BASE"

chmod +x $BASE/lazarus/lazarus.desktop
chmod +x $BASE/lazarus/lazarus.sh
chmod +x $BASE/lazarus/tools/install/*.sh
mv $BASE/lazarus/lazarus.desktop $BASE/lazarus.desktop

# Install an application shortcut
case $SHORTCUT in
    [yY][eE][sS]|[yY]) 
		if type desktop-file-install > /dev/null; then
			desktop-file-install --dir="$HOME/.local/share/applications" "$BASE/lazarus.desktop"
		else
			cp "$BASE/lazarus.desktop" "$HOME/.local/share/applications"
		fi
		echo
		;;
    *)
		echo 
		;;
esac

