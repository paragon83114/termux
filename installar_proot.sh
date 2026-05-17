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
apt install -y neovim curl wget git nodejs npm docker-compose lsd bat tree procps
# curl -fsSL https://opencode.ai/install | bash
# npm install -g @google/gemini-cli
dir="/usr/bin"
url="https://github.com/zellij-org/zellij/releases/latest/download/zellij-aarch64-unknown-linux-musl.tar.gz"
curl --location "$url" | tar -C "$dir" -xz

# ~/.config/tmux/tmux.conf
# Prefijo
unbind C-b
set -g prefix ¡
bind ¡ send-prefix
# Numeracion
set -g base-index 1
set -g pane-base-index 1
# True colors support
set -g default-terminal "${TERM}"
set -as terminal-overrides ",*:RGB"
# Status Bar
set -g status-style bg=default,fg=black,bright
set -g status-left ""
set -g status-right "#[fg=green,nobold]󰍛 #(free -h | awk '/^Mem:/ {print $3 \"/\" $2}')  #[fg=black,bright]%H:%M "
set -g window-status-format " #I "
set -g window-status-current-format " #I "
set -g window-status-bell-style "bg=red,nobold"
set -g window-status-current-style "#{?windows_zoomed_flag,bg=yellow,fg=green,nobold}"
set -g renumber-windows on
# Estilo de las líneas (heavy, single o double)
set -g pane-border-lines heavy
set -g pane-border-style fg=black,bright
set -g pane-active-border-style fg=green
set -g escape-time 0
set -g mouse on
set -g repeat-time 1000
set -g history-limit 1000
# Navegación entre paneles: Alt + Flechas (Sin prefijo)
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
# Creación de paneles: Alt + Shift + Flechas (Sin prefijo)
bind -n M-S-Left split-window -h -b
bind -n M-S-Right split-window -h
bind -n M-S-Up split-window -v -b
bind -n M-S-Down split-window -v
# Navegación inteligente con Alt (Meta) + Número: Salta si existe, crea si no.
bind -n M-1 if-shell "tmux select-window -t :1" "" "new-window -t :1"
bind -n M-2 if-shell "tmux select-window -t :2" "" "new-window -t :2"
bind -n M-3 if-shell "tmux select-window -t :3" "" "new-window -t :3"
bind -n M-4 if-shell "tmux select-window -t :4" "" "new-window -t :4"
bind -n M-5 if-shell "tmux select-window -t :5" "" "new-window -t :5"
bind -n M-6 if-shell "tmux select-window -t :6" "" "new-window -t :6"
bind -n M-7 if-shell "tmux select-window -t :7" "" "new-window -t :7"
bind -n M-8 if-shell "tmux select-window -t :8" "" "new-window -t :8"
bind -n M-9 if-shell "tmux select-window -t :9" "" "new-window -t :9"
# Cierra venatana con Alt X
bind -n M-x kill-window
# Cierra pane con Alt Shift X
bind -n M-q kill-pane
