#!/bin/bash

echo -e "Chequeando si docker está instalado..."
OS_NAME=$(grep -E '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')

if [[ "$(echo "$OS_NAME" | tr '[:lower:]' '[:upper:]')" == "UBUNTU" ]]; then
    echo "Sistema operativo validado: Ubuntu."
    
    read -p "¿Quiere instalar docker? (Y/N): " RESPUESTA
    
    if [[ "${RESPUESTA,,}" == "y" ]]; then
        echo "Ejecutando install_docker.sh..."
        
        if [[ -x "./install_docker.sh" ]]; then
            ./install_docker.sh
        else
            echo "Error: 'install_docker.sh' no existe o no tiene permisos de ejecución."
            exit 1
        fi
    else
        echo "Instalación de Docker omitida. Continuando..."
    fi
else
    echo -e "\t>> Error: Este sistema no es Ubuntu (Detectado: $OS_NAME). Cancelando instalación."
    exit 1
fi

echo -e "\t>> Inicializando container..."

docker run -d --name ownCloud -p 8080:80 -v "$PWD/datos_owncloud:/var/www/html" owncloud

if [[ ! -e .log ]]; then
    echo -e "\n\tChequea 127.0.0.1:8080 para configurar tu usuario de ownCloud!\n"
fi

