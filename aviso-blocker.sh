#!/bin/bash

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

echo El bloqueador ya está funcionando.
echo Si estás viendo esto, es porque lo estás ejecutando desde una terminal.
echo Configúralo para que ejecute en segundo plano al iniciar el ordenador.

# Bucle infinito para cerrar la ventana de Zenity en cuanto aparezca
while true; do
    pkill -f "zenity --error --text=Este tipo de software non está permitido."
    sleep 0.5  # Espera medio segundo antes de volver a comprobar
done
