#!/usr/bin/env bash
# ============================================================================
# subir-a-github.sh — Sube el código del sitio (live o demo) al repositorio
#                     GitHub conectado a Lovable.
#
# Uso:
#   ./subir-a-github.sh /var/www/citas-live
#
# Parámetro 1 (obligatorio): ruta origen con el código del sitio.
#
# Qué hace:
#   1. Clona el repositorio en /opt/citas/repo (o hace pull si ya existe).
#   2. Copia el código del origen a repo/php-app/ SIN secretos ni datos
#      (.env, config.properties, storage/, logs).
#   3. Muestra qué archivos cambiaron y pide confirmación.
#   4. Hace commit y push a la rama actual (normalmente main).
#
# Requisitos: git y rsync instalados. Si el repo es privado, git pedirá
# usuario y token de GitHub con permiso de escritura.
# ============================================================================

set -euo pipefail

# ---- Configuración --------------------------------------------------------
REPO_URL="https://github.com/TU_USUARIO/TU_REPO.git"   # <-- AJUSTA ESTO
REPO_DIR="/opt/citas/repo"                              # dónde vive el clon
APP_SUBDIR="php-app"                                    # subcarpeta del código en el repo
# ---------------------------------------------------------------------------

ORIGEN="${1:-}"

if [[ -z "$ORIGEN" ]]; then
  echo "Uso: $0 /ruta/al/sitio   (ejemplo: $0 /var/www/citas-live)"
  exit 1
fi

if [[ ! -d "$ORIGEN/app" || ! -d "$ORIGEN/public" ]]; then
  echo "ERROR: '$ORIGEN' no parece una instalación del sistema (no tiene app/ y public/)."
  exit 1
fi

if [[ "$REPO_URL" == *"TU_USUARIO"* ]]; then
  echo "ERROR: edita el script y pon la URL real de tu repositorio en REPO_URL."
  exit 1
fi

echo "==> Origen: $ORIGEN"

# 1. Clonar o actualizar el repositorio
if [[ -d "$REPO_DIR/.git" ]]; then
  echo "==> Actualizando clon existente en $REPO_DIR"
  git -C "$REPO_DIR" fetch origin
  git -C "$REPO_DIR" pull --ff-only
else
  echo "==> Clonando $REPO_URL en $REPO_DIR"
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$REPO_DIR"
fi

DESTINO="$REPO_DIR/$APP_SUBDIR"
mkdir -p "$DESTINO"

# 2. Copiar código sin secretos ni datos
echo "==> Copiando código (sin .env, config.properties, storage/ ni logs)"
rsync -a --delete \
  --exclude '.env' \
  --exclude 'config/config.properties' \
  --exclude 'storage/' \
  --exclude '*.log' \
  "$ORIGEN/" "$DESTINO/"

# 3. Mostrar cambios
cd "$REPO_DIR"
if git diff --quiet && git diff --cached --quiet && [[ -z "$(git status --porcelain)" ]]; then
  echo "==> No hay cambios respecto a GitHub. Nada que subir."
  exit 0
fi

echo
echo "==> Archivos que cambiarán:"
git status --short
echo
read -r -p "¿Subir estos cambios a GitHub? [s/N] " RESP
if [[ ! "$RESP" =~ ^[sS]$ ]]; then
  echo "Cancelado. Los archivos quedaron copiados en $DESTINO por si quieres revisarlos."
  exit 0
fi

# 4. Commit y push
RAMA="$(git branch --show-current)"
[[ -z "$RAMA" ]] && RAMA="main"
MENSAJE="Actualización desde servidor ($(basename "$ORIGEN")) $(date +%Y-%m-%d)"

git add -A
git commit -m "$MENSAJE"
git push origin "$RAMA"

echo
echo "==> Listo. Cambios subidos a la rama '$RAMA'."
echo "    Lovable se sincroniza solo con GitHub; verifica ahí que aparezcan los archivos."
