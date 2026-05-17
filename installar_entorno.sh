#!/data/data/com.termux/files/usr/bin/bash

[ ! -e ~/storage ] && termux-setup-storage
touch ~/.hushlogin
termux-change-repo
pkg update
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install tur-repo -y
pkg install lsd -y
pkg install bat -y
pkg install neovim -y
pkg install zellij -y
pkg install termux-api -y
pkg install tree -y
pkg install mpv -y
pkg install which -y
pkg install htop -y
pkg install nmap -y
pkg install wget -y
pkg install yt-dlp -y
pkg install proot-distro -y
pkg install nodejs -y
pkg install curl -y
pkg install git -y
pkg install python-pip -y
sed -i 's/^# fullscreen = true/fullscreen = true/' ~/.termux/termux.properties
sed -i 's/^# *extra-keys = \[\[ESC.*/extra-keys = []/' ~/.termux/termux.properties
sed -i 's/^# back-key=escape/back-key=escape/' ~/.termux/termux.properties
mkdir -p ~/.config/zellij && zellij setup --dump-config > ~/.config/zellij/config.kdl
echo "show_startup_tips false" >> ~/.config/zellij/config.kdl
echo "show_release_notes false" >>  ~/.config/zellij/config.kdl
[ ! -e ~/.termux/font.ttf ] && curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf -o ~/.termux/font.ttf
termux-reload-settings
mkdir -p ~/.config/nvim && echo 'vim.opt.clipboard = "unnamedplus"' > ~/.config/nvim/init.lua

# DEBIAN
npm install -g @google/gemini-cli

# OPENCODE
proot-distro install debian
proot-distro login debian --shared-tmp -- bash -c "
    apt update && \
    apt upgrade -y && \
    apt install -y curl git ca-certificates && \
    curl -fsSL https://opencode.ai/install | bash
"
cat << 'EOF' > /data/data/com.termux/files/usr/bin/opencode
#!/data/data/com.termux/files/usr/bin/bash
proot-distro login --shared-tmp --work-dir "$PWD" debian -- opencode "$@" 2>/dev/null
EOF
chmod +x /data/data/com.termux/files/usr/bin/opencode

cat << 'EOF' > ~/.bashrc
#!/data/data/com.termux/files/usr/bin/bash
alias t="tree -Ch"
alias c="clear"
alias ls="lsd"
alias l="lsd -l --date +%Y/%m/%d --blocks permission,user,size,date,name"
alias ll="lsd -lha --date +%Y/%m/%d --blocks permission,user,size,date,name"
alias m="cd /data/data/com.termux/files/home/storage/music;mpv --shuffle --no-video *.mp3"
alias yt="termux-open-url https://www.youtube.com"
alias tw="termux-open-url https://www.twitch.com"
alias cr="termux-open-url https://www.google.com"
alias nf="am start -n com.netflix.mediaclient/com.netflix.mediaclient.ui.launch.UIWebViewActivity > /dev/null 2>&1"
?() {
  gemini -m gemini-2.5-flash -p "$*"
}
clear
[ $(pgrep -c zellij) -eq 0 ] && zellij options --theme tokyo-night-dark
EOF
