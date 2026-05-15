#!/bin/bash

# ============================================================
#  opencode — Lanzador para Termux
#  Ejecuta opencode dentro de un contenedor proot-distro (Debian)
# ============================================================

# --- Configuracion (editar segun sea necesario) ---
PROOT_DISTRO="debian"                          # Distribucion del contenedor
OPCODE_BIN="/root/.opencode/bin/opencode"      # Ruta al binario dentro del contenedor
DEBUG=false                                    # true = muestra errores de proot-distro

# --- Validacion de dependencias ---
if ! command -v proot-distro >/dev/null 2>&1; then
	echo "Error: 'proot-distro' no esta instalado."
	echo "Instalalo con: pkg install proot-distro"
	exit 1
fi

# --- Variables de entorno: excluir las que establece proot-distro por defecto ---
EXCLUDE_REGEX="^(PATH|LD_PRELOAD|LD_LIBRARY_PATH|PREFIX|HOME|PWD|OLDPWD|SHELL|IFS|_|SHLVL|PROMPT_COMMAND|TERMCAP|LS_COLORS|TERM)="

# Recolectar variables de entorno del host (excepto las excluidas)
ENV_ARGS=()
while IFS= read -r line; do
	if [[ -n "$line" && ! "$line" =~ $EXCLUDE_REGEX ]]; then
		ENV_ARGS+=("--env" "$line")
	fi
done < <(env)

# Forzar variables esenciales dentro del contenedor
ENV_ARGS+=(
	"--env" "SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt"
	"--env" "TERM=$TERM"
	"--env" "HOME=/root"
)

# --- Limpiar variables problematicas del host ---
unset LD_PRELOAD

# --- Ejecutar opencode dentro del contenedor ---
if [ "$DEBUG" = true ]; then
	# Con stderr visible para depuracion
	exec proot-distro login \
		"${ENV_ARGS[@]}" \
		--termux-home \
		--shared-tmp \
		--work-dir "$PWD" \
		"$PROOT_DISTRO" \
		-- "$OPCODE_BIN" "$@"
else
	# Ocultar errores de proot-distro (estandar)
	exec proot-distro login \
		"${ENV_ARGS[@]}" \
		--termux-home \
		--shared-tmp \
		--work-dir "$PWD" \
		"$PROOT_DISTRO" \
		-- "$OPCODE_BIN" "$@" 2>/dev/null
fi
