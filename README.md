git clone https://github.com/rbenyounes/unattended-iso

# create boot usb
wget https://mirror.csclub.uwaterloo.ca/linuxmint/stable/20.1/linuxmint-20.1-xfce-64bit.iso
burn it to usb

# install mint manually on the host machine
boot from usb
language: english
keyboard layout: english us
wireless: connect to network
install multimedia codecs
erase disk and install Linux Mint
timezone : montreal
user: romdhane
password: romdhane
restart now
remove media
open new session with romdhane account
create ben account and set it to "desktop user"
set Admin for romdhane
configure autologon

# on the host machine
sudo apt-get install openssh-server -y
sudo apt-get install python -y

# on the control machine
on the control machine execute: ssh-copy-id -i ~/.ssh/id_rsa.pub romdhane@192.168.0.161

