#!/usr/bin/env bash
# Fail on any error
set -e

# Set version info
export BOX_VERSION_BASE="1.0.1"
export UBUNTU_2004_BASE_VERSION="20.04.3"
export UBUNTU_2004_BASE_ISO="ubuntu-${UBUNTU_2004_BASE_VERSION}-live-server-amd64.iso"
export UBUNTU_2004_BASE_ISO_SHA256="f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"

# Set versions requested of main components (These will be used in Packer and passed to Ansible downstream)
export ANSIBLE_VERSION="5.2.0"
export VBOXADD_VERSION="6.1.30"

# Set versions of supported tools, if they don't match, a warning will be shown on screen
export VIRTUALBOX_VERSION="6.1.30r148432"
export PACKER_VERSION="1.7.9"
export VAGRANT_VERSION="2.2.19"

# ############################################################################################## #
# Below this point there should be no need to edit anything, unless you know what you are doing! #
# ############################################################################################## #

# Generate the final version of the box, adding the date string of today
export BOX_VERSION=${BOX_VERSION_BASE}-$(date +'%Y%m%d')

echo "Testing if all required tools are installed, please wait..."

# Check if all required tools are installed
if ( ! ( vboxmanage --version >/dev/null 2>&1 && packer version >/dev/null 2>&1 && vagrant version >/dev/null 2>&1 ) )
then
    echo "ERROR: One of the required tools (VirtualBox, Vagrant, and Packer) is not installed. Cannot continue."
    exit 1
fi

# Check the tool versions
INSTALLED_VIRTUALBOX_VERSION=$(vboxmanage --version)
INSTALLED_PACKER_VERSION=$(packer --version)
INSTALLED_VAGRANT_VERSION=$(vagrant --version | awk '{print $2}')

if [[ $INSTALLED_VIRTUALBOX_VERSION != $VIRTUALBOX_VERSION || $INSTALLED_PACKER_VERSION != $PACKER_VERSION || $INSTALLED_VAGRANT_VERSION != $VAGRANT_VERSION ]]
then
    echo "WARNING: One of the tool versions does not match the tested versions. Your mileage may vary..."
    echo " * Using VirtualBox version ${INSTALLED_VIRTUALBOX_VERSION} (tested with version ${VIRTUALBOX_VERSION})"
    echo " * Using Packer version ${INSTALLED_PACKER_VERSION} (tested with version ${PACKER_VERSION})"
    echo " * Using Vagrant version ${INSTALLED_VAGRANT_VERSION} (tested with version ${VAGRANT_VERSION})"
    echo ""
    echo -n "To break, press Ctrl-C now, otherwise press Enter to continue"
    read foo
fi

echo "All required tools found. Continuing."

# Validate build config
echo "Validating build json files"
packer validate ubuntults-nocloud.json

# Run the actual build
echo "Building box version ${BOX_VERSION}"
packer build -force -on-error=cleanup ubuntults-nocloud.json