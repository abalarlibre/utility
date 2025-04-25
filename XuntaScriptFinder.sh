#!/bin/bash

#######################################################
#              XuntaScriptFinder.sh                   #
# Function: find all scripts made by Xunta de Galicia #
#             Created by abalarlibre                  #
#######################################################

# Comprobar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo -e "\033[1;31m¡Este script debe ejecutarse como root!\033[0m"
    exit 1
fi

# Banner de marca personal
clear
cat <<'EOF'
########################################################
#        _           _            _ _ _                #
#       | |         | |          | (_) |               #
#   __ _| |__   __ _| | __ _ _ __| |_| |__  _ __ ___   #
#  / _` | '_ \ / _` | |/ _` | '__| | | '_ \| '__/ _ \  #
# | (_| | |_) | (_| | | (_| | |  | | | |_) | | |  __/  #
#  \__,_|_.__/ \__,_|_|\__,_|_|  |_|_|_.__/|_|  \___|  #
#                                                      #
#            Copyright (C) 2025, abalarlibre           #
########################################################
EOF
sleep 2
clear

# Mensaje de inicio
echo -e "\033[1;36mEste script se encarga de buscar todos los scripts creados o modificados por la Xunta de Galicia en tu equipo, para después copiarlos a una carpeta individual para análisis posterior.\033[0m"
echo
echo -e "\033[1;36mEstamos escaneando tu equipo. Este proceso tardará entre 1 o 2 minutos.\033[0m"
sleep 3

# Variables
DESTINO="$(pwd)/XuntaScripts"
DESTINO_SCRIPTS="$DESTINO/scripts"
INFO="$DESTINO/Info.txt"
USUARIO="usuario"
TEMP_LIST="/tmp/xunta_encontrados.txt"
SCRIPT_DIR="$(pwd)"

# Crear directorios
mkdir -p "$DESTINO_SCRIPTS"
chown -R "$USUARIO:$USUARIO" "$DESTINO"

# Limpiar Info.txt y lista temporal si existen
> "$INFO"
> "$TEMP_LIST"

# Guardar hora de inicio
INICIO=$(date +%s)
FECHA_HORA=$(date "+%Y-%m-%d %H:%M:%S")

# Buscar scripts y guardar en lista temporal
find / \
    -path "/home/$USUARIO" -prune -o \
    -path "$SCRIPT_DIR" -prune -o \
    -path "/media" -prune -o \
    -type f \( -name "*.sh" -o -name "*.bash" -o -name "*.py" -o -name "*.php" -o -name "*.js" \) -print 2>/dev/null > "$TEMP_LIST"

# Contador de archivos copiados
contador=0

# Procesar cada archivo encontrado
while read -r archivo; do
    if grep -q "xunta" "$archivo"; then
        # Copiar respetando ruta relativa dentro de scripts/
        RUTA_DESTINO="$DESTINO_SCRIPTS$(dirname "$archivo")"
        mkdir -p "$RUTA_DESTINO"
        cp "$archivo" "$RUTA_DESTINO/"

        # Cambiar propietario y permisos del archivo copiado
        chown "$USUARIO:$USUARIO" "$RUTA_DESTINO/$(basename "$archivo")"
        chmod 644 "$RUTA_DESTINO/$(basename "$archivo")"

        # Log bonito en terminal
        echo -e "\033[1;32m✅ Script encontrado en:\033[0m \033[1;34m$archivo\033[0m"

        # Registrar en Info.txt
        echo "$archivo" >> "$INFO"

        ((contador++))
    fi
done < "$TEMP_LIST"

# Cambiar propietario de toda XuntaScripts al final (por si se crearon carpetas nuevas dentro)
chown -R "$USUARIO:$USUARIO" "$DESTINO"

# Guardar hora de fin
FIN=$(date +%s)
TIEMPO=$((FIN - INICIO))

# Escribir cabecera en Info.txt
sed -i "1i Ejecutado el: $FECHA_HORA\nDuración: ${TIEMPO}s\n\nRutas encontradas:" "$INFO"

# Borrar lista temporal
rm "$TEMP_LIST"

# Mensaje final
echo
echo -e "\033[1;36mCopia finalizada. Se copiaron $contador scripts.\033[0m"
echo -e "\033[1;36mDetalles en: $INFO\033[0m"
