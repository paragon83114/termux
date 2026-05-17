[ ! -e ~/storage ] && termux-setup-storage
touch ~/.hushlogin
termux-change-repo
pkg update &>/dev/null
pkg upgrade -y -o Dpkg::Options::="--force-confnew" &>/dev/null
sed -i 's/^# fullscreen = true/fullscreen = true/' ~/.termux/termux.properties
sed -i 's/^# *extra-keys = \[\[ESC.*/extra-keys = []/' ~/.termux/termux.properties
sed -i 's/^# back-key=escape/back-key=escape/' ~/.termux/termux.properties
pkg install -y proot-distro
proot-distro install debian
echo "proot-distro login debian" > .bashrc
