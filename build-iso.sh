#!/bin/bash

set -e
# lookup specific binaries
: "${BIN_7Z:=$(type -P 7z)}"
: "${BIN_XORRISO:=$(type -P xorriso)}"
: "${BIN_CPIO:=$(type -P gnucpio || type -P cpio)}"

# get parameters
SSH_PUBLIC_KEY_FILE=${1:-"$HOME/.ssh/id_rsa.pub"}
#SOURCE_ISO=${2:-"$HOME/Downloads/linuxmint-20.1-xfce-64bit.iso"}
#TARGET_ISO=${2:-"`pwd`/linuxmint-20.1-xfce-64bit-unattended.iso"}
SOURCE_ISO=${2:-"$HOME/Downloads/ubuntu-20.04.2.0-desktop-amd64.iso"}
TARGET_ISO=${2:-"`pwd`/ubuntu-20.04.2.0-desktop-amd64-unattended.iso"}

# check if ssh key exists
if [ ! -f "$SSH_PUBLIC_KEY_FILE" ];
then
    echo "Error: public SSH key $SSH_PUBLIC_KEY_FILE not found!"
    exit 1
fi

# get directories
CURRENT_DIR="`pwd`"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DISC_DIR="`mktemp -d`"
TMP_INITRD_DIR="`mktemp -d`"

# extract iso
"$BIN_7Z" x "$SOURCE_ISO" "-o$TMP_DISC_DIR"

# prepare assets
cd "$TMP_INITRD_DIR"
mkdir "./custom"
cp "$SCRIPT_DIR/custom/preseed.cfg" "./preseed.cfg"
cp "$SSH_PUBLIC_KEY_FILE" "./custom/userkey.pub"
cp "$SCRIPT_DIR/custom/ssh-host-keygen.service" "./custom/ssh-host-keygen.service"




# build iso
cd "$TMP_DISC_DIR"
#rm -r '[BOOT]'
#"$BIN_XORRISO" -as mkisofs -r -V "Linux Mint 20.1 Xfce 64-bit" \
#	-J -b isolinux/isolinux.bin -c isolinux/boot.cat \
#	-no-emul-boot -boot-load-size 4 -boot-info-table -input-charset utf-8 \
#	-isohybrid-mbr "$SCRIPT_DIR/custom/isohdpfx.bin" -eltorito-alt-boot \
#	-e boot/grub/efi.img \
#	-no-emul-boot -isohybrid-gpt-basdat -o "$TARGET_ISO" ./
#mkisofs -D -r -V "Linux Mint 20.1 Xfce 64-bit" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o "$TARGET_ISO" ./

# go back to initial directory
cd "$CURRENT_DIR"

# delete all temporary directories
#rm -r "$TMP_DISC_DIR"
rm -r "$TMP_INITRD_DIR"

# done
echo "Next steps: install system, login via root, adjust the authorized keys, set a root password (if you want to), deploy via ansible (if applicable), enjoy!"

