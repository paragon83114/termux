#!/bin/bash

# Colores para salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuración
DEBIAN_DISTRO="debian"
OLLAMA_VER="0.30.0-rc17"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
DOTFILES_REPO="https://github.com/paragon83114/dotfiles.git"

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

set -e

# ==========================================
# VALIDACIONES INICIALES
# ==========================================
if [ -z "$TERMUX_VERSION" ]; then
    error "Este script debe ejecutarse dentro de Termux."
fi

# ==========================================
# FASE 1: Setup de Termux
# ==========================================
log "Iniciando setup de Termux..."

# Storage
if [ ! -e ~/storage ]; then
    log "Configurando acceso al almacenamiento..."
    termux-setup-storage
else
    log "Almacenamiento ya configurado."
fi

# Hushlogin para evitar el mensaje de bienvenida de Termux cada vez
touch ~/.hushlogin

# Repositorios y Actualización
log "Actualizando paquetes de Termux (esto puede tardar)..."
termux-change-repo
pkg update -y && pkg upgrade -y -o Dpkg::Options::="--force-confnew"

# Propiedades de Termux
log "Configurando termux.properties..."
PROP_FILE="$HOME/.termux/termux.properties"
mkdir -p "$(dirname "$PROP_FILE")"
sed -i 's/^# *fullscreen = true/fullscreen = true/' "$PROP_FILE"
sed -i 's/^# *extra-keys = .*/extra-keys = []/' "$PROP_FILE"
sed -i 's/^# *back-key=escape/back-key=escape/' "$PROP_FILE"

# Fuentes
if [ ! -e ~/.termux/font.ttf ]; then
    log "Descargando JetBrains Mono Nerd Font..."
    curl -L "$FONT_URL" -o ~/.termux/font.ttf
    termux-reload-settings
fi

# Proot-distro
pkg install -y proot-distro
if ! proot-distro list | grep -q "Installed.*$DEBIAN_DISTRO"; then
    log "Instalando Debian en proot..."
    proot-distro install "$DEBIAN_DISTRO"
else
    warn "Debian ya está instalado, saltando instalación."
fi

# ==========================================
# FASE 2: Setup dentro del proot
# ==========================================
log "Entrando al proot para configuración interna..."

proot-distro login "$DEBIAN_DISTRO" -- /bin/bash << PROOT_EOF
set -e

# Colores dentro del proot
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "\${GREEN}[PROOT] Actualizando Debian e instalando paquetes...\${NC}"
apt update && apt upgrade -y
apt install -y neovim curl wget git nodejs npm docker-compose lsd bat tree procps mpv stow ripgrep tmux fzf glow locales

# Instalaciones externas
echo -e "\${GREEN}[PROOT] Instalando Starship, OpenCode, Gemini-CLI y Ollama...\${NC}"
curl -sS https://starship.rs/install.sh | sh -s -- -y
curl -fsSL https://opencode.ai/install | bash
npm install -g @google/gemini-cli
curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION=$OLLAMA_VER sh

# Locale
echo -e "\${GREEN}[PROOT] Configurando Locales...\${NC}"
sed -i 's/^# *en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen

# Dotfiles con Backups
echo -e "\${GREEN}[PROOT] Configurando Dotfiles...\${NC}"
cd ~
[ -d "dotfiles" ] && rm -rf dotfiles # Re-clonar para asegurar última versión
git clone "$DOTFILES_REPO"

# Función para backup seguro
safe_backup() {
    if [ -e "\$1" ]; then
        echo "Haciendo backup de \$1"
        mv "\$1" "\$1.bak_\$(date +%Y%m%d_%H%M%S)"
    fi
}

safe_backup ~/.bashrc
safe_backup ~/.config/bat
safe_backup ~/.config/lsd
safe_backup ~/.config/starship.toml
safe_backup ~/.config/tmux

mkdir -p ~/.config
cd ~/dotfiles
stow bash bat lsd starship tmux
cp ~/dotfiles/keys/keys.md ~/

echo -e "\${GREEN}=== Setup del proot completado ===\${NC}"
PROOT_EOF

# ==========================================
# FINALIZACIÓN
# ==========================================
log "Configurando acceso automático al proot..."
# Configurar el login automático en el .bashrc de Termux
if ! grep -q "proot-distro login $DEBIAN_DISTRO" ~/.bashrc; then
    echo "proot-distro login $DEBIAN_DISTRO" >> ~/.bashrc
fi

log "Instalación completa. Reinicia Termux para entrar al proot."
