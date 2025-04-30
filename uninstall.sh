#!/bin/bash

# Verifica se é root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script deve ser executado como root" >&2
    exit 1
fi

# Configurações
APP_NAME="template-complete"
INSTALL_DIR="/opt/$APP_NAME"
BIN_DIR="/usr/local/bin"
DESKTOP_DIR="/usr/share/applications"
ICON_DIR="/usr/share/icons/hicolor/48x48/apps"

# Remover arquivos
echo "Removendo arquivos de instalação..."
rm -rf "$INSTALL_DIR"
rm -f "$BIN_DIR/$APP_NAME"
rm -f "$DESKTOP_DIR/$APP_NAME.desktop"
rm -f "$ICON_DIR/$APP_NAME.png"

# Atualizar banco de dados de desktop
update-desktop-database "$DESKTOP_DIR"

echo "Desinstalação concluída com sucesso!"