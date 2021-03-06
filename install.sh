#!/bin/bash

LIBRARY_VERSION=`cat library/setup.cfg | grep version | awk -F" = " '{print $2}'`
LIBRARY_NAME=`cat library/setup.cfg | grep name | awk -F" = " '{print $2}'`

printf "$LIBRARY_NAME $LIBRARY_VERSION Python Library: Installer\n\n"

if [ $(id -u) -ne 0 ]; then
	printf "Script must be run as root. Try 'sudo ./install.sh'\n"
	exit 1
fi

function apt_pkg_install {
	PACKAGE=$1
	printf "Checking for $PACKAGE\n"
	dpkg -L $PACKAGE > /dev/null 2>&1
	if [ "$?" == "1" ]; then
		sudo apt update
		sudo apt install -y python-setuptools python-dev python-psutil
	fi
}

cd library

printf "Installing for Python 2..\n"
apt_pkg_install python-setuptools python-dev python-psutil
python setup.py install

if [ -f "/usr/bin/python3" ]; then
	printf "Installing for Python 3..\n"
	apt_pkg_install python3-setuptools python3-dev python3-psutil
	python3 setup.py install
fi

cd ..

printf "Done!\n"
