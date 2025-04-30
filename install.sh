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

# Dependências para Fedora/Rocky
DEPENDENCIES=(
    python3
    python3-tkinter
    python3-pip
    ImageMagick  # Para criar ícone padrão se necessário
)

# Verificar e instalar dependências
echo "Instalando dependências..."
dnf check-update
for pkg in "${DEPENDENCIES[@]}"; do
    if ! rpm -q "$pkg" &> /dev/null; then
        dnf install -y "$pkg"
    fi
done

# Criar diretórios
echo "Criando diretórios de instalação..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$ICON_DIR"

# Copiar arquivos do projeto
echo "Copiando arquivos do projeto..."
cp -r src/* "$INSTALL_DIR/"

# Criar executável
echo "Criando executável..."
cat > "$BIN_DIR/$APP_NAME" <<EOF
#!/bin/bash
cd "$INSTALL_DIR"
python3 main.py
EOF
chmod +x "$BIN_DIR/$APP_NAME"

# Criar ícone (substitua por um ícone real se tiver)
echo "Criando ícone padrão..."
convert -size 48x48 xc:blue -fill white -draw 'circle 24,24 24,1' "$ICON_DIR/$APP_NAME.png" 2>/dev/null || \
echo "Aviso: Não foi possível criar ícone padrão. ImageMagick pode não estar instalado."

# Criar arquivo .desktop
echo "Criando lançador..."
cat > "$DESKTOP_DIR/$APP_NAME.desktop" <<EOF
[Desktop Entry]
Version=1.0
Name=Meu Projeto
Comment=Aplicação desenvolvida em Python com Tkinter
Exec=$BIN_DIR/$APP_NAME
Icon=$APP_NAME
Terminal=false
Type=Application
Categories=Utility;Application;
StartupNotify=true
EOF

# Atualizar banco de dados de desktop
update-desktop-database "$DESKTOP_DIR"

echo "Instalação concluída com sucesso!"
echo "O aplicativo pode ser iniciado pelo menu de aplicativos ou pelo terminal com o comando: $APP_NAME"