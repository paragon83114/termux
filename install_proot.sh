#!/bin/bash
set -e

# ==========================================
# FASE 1: Setup de Termux (fuera de proot)
# ==========================================

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

# ==========================================
# FASE 2: Setup dentro del proot (Debian)
# ==========================================

proot-distro login debian -- /bin/bash << 'PROOT_EOF'
set -e

apt update
apt upgrade -y
apt install -y neovim curl wget git nodejs npm docker-compose lsd bat tree procps mpv stow
curl -sS https://starship.rs/install.sh | sh
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
# bash completions
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
# starship
eval "$(starship init bash)"
# opencode
export PATH=/root/.opencode/bin:$PATH
[ $(pgrep -c tmux) -eq 0 ] && tmux
EOF

echo "=== Setup del proot completado ==="
PROOT_EOF

echo "proot-distro login debian" > ~/.bashrc
echo "=== Instalacion completa. Reinicia Termux para entrar al proot ==="
