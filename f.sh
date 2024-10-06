#!/bin/zsh

cd

# Crear directorio temporal para la desinstalación
mkdir -p "$HOME/.tmp_francinette"
git clone https://github.com/WaRtr0/francinette-image.git "$HOME/.tmp_francinette/francinette-image"

# Ejecutar scripts de eliminación
source "$HOME/.tmp_francinette/francinette-image/utils/remove_docker.sh"
source "$HOME/.tmp_francinette/francinette-image/utils/remove_zshrc.sh"

# Limpiar directorios
rm -rf "$HOME/francinette-image" "$HOME/.tmp_francinette"

# Mensaje de desinstalación exitosa
echo -e "\033[0;36m[Francinette] \033[0;37mUninstalled \033[0;32mOK\033[0m"  # \033[0m restablece el color

# Clonar el nuevo repositorio
rm -rf francinette
git clone --recursive https://github.com/xicodomingues/francinette.git

cd francinette || exit

# Instalar requisitos
pip install -r requirements.txt

# Crear el script tester.sh
cat << 'EOF' > tester.sh
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_dir=$PWD
version=68
cd "$current_dir" || exit
python3 "$DIR/main.py" "$@"
EOF

cd

# Añadir alias al archivo .zshrc si no existe
RC_FILE="$HOME/.zshrc"
if ! grep -q "alias paco=" "$RC_FILE"; then
    echo "alias paco='$HOME/francinette/tester.sh'" >> "$RC_FILE"
fi

# Cargar el archivo de configuración
source "$RC_FILE"