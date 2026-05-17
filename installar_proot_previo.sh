[ ! -e ~/storage ] && termux-setup-storage
touch ~/.hushlogin
termux-change-repo
pkg update &>/dev/null
pkg upgrade -y -o Dpkg::Options::="--force-confnew" &>/dev/null
sed -i 's/^# fullscreen = true/fullscreen = true/' ~/.termux/termux.properties
sed -i 's/^# *extra-keys = \[\[ESC.*/extra-keys = []/' ~/.termux/termux.properties
sed -i 's/^# back-key=escape/back-key=escape/' ~/.termux/termux.properties
[ ! -e ~/.termux/font.ttf ] && curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf -o ~/.termux/font.ttf
termux-reload-settings
pkg install -y proot-distro
proot-distro install debian
echo "proot-distro login debian" > .bashrc

# Instalacion posterior en proot
apt update
apt upgrade
apt install -y neovim curl wget git nodejs npm docker-compose lsd bat tree procps mpv
curl -fsSL https://opencode.ai/install | bash
npm install -g @google/gemini-cli
curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION=0.30.0-rc17 sh
cat << 'EOF' > ~/.bashrc
alias t="tree -Ch"
alias c="clear"
alias ls="lsd"
alias l="lsd -l --date +%Y/%m/%d --blocks permission,user,size,date,name"
alias ll="lsd -lha --date +%Y/%m/%d --blocks permission,user,size,date,name"
alias nano="nvim"
?() {
  gemini -m gemini-2.5-flash -p "$*"
}
export PATH=/root/.opencode/bin:$PATH
[ $(pgrep -c tmux) -eq 0 ] && tmux
EOF
