#!/data/data/com.termux/files/usr/bin/bash

[ ! -e storage ] && termux-setup-storage
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
sed -i 's/^# fullscreen = true/fullscreen = true/' ~/.termux/termux.properties
sed -i 's/^# *extra-keys = \[\[ESC.*/extra-keys = []/' ~/.termux/termux.properties
sed -i 's/^# back-key=escape/back-key=escape/' ~/.termux/termux.properties
mkdir -p ~/.config/zellij && zellij setup --dump-config > ~/.config/zellij/config.kdl
echo "show_startup_tips false" >> ~/.config/zellij/config.kdl
echo "show_release_notes false" >>  ~/.config/zellij/config.kdl
[ ! -e ~/.termux/font.ttf ] && curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf -o ~/.termux/font.ttf
termux-reload-settings
cat << 'EOF' > ~/.bashrc
alias t="tree -Ch"
alias c="clear"
alias ls="lsd"
alias l="lsd -l"
alias ll="lsd -lha"
alias m="cd /data/data/com.termux/files/home/storage/music;mpv --shuffle --no-video *.mp3"
alias yt="termux-open-url https://www.youtube.com"
alias tw="termux-open-url https://www.twitch.com"
alias cr="termux-open-url https://www.google.com"
alias nf="am start -n com.netflix.mediaclient/com.netflix.mediaclient.ui.launch.UIWebViewActivity > /dev/null 2>&1"
?() {
  gemini -m gemini-2.5-flash -p "$*"
}
clear
[ $(pgrep -c zellij) -eq 0 ] && zellij
EOF
mkdir -p ~/.config/nvim && echo 'vim.opt.clipboard = "unnamedplus"' > ~/.config/nvim/init.lua
curl -fsSL https://raw.githubusercontent.com/DevCoreXOfficial/core-termux/main/install.sh | bash
core install ai
cat << 'EOF' > ~/ai.help
• Qwen Code (qwen)
• Gemini CLI (gemini)
• Mistral Vibe (vibe)
• OpenClaude (openclaude)
• Claude Code (claude)
• OpenClaw (openclaw)
• Ollama (ollama)
• Codex (codex)
• OpenCode (opencode)
• Engram (engram)
EOF
kill -9 -1
