#!/bin/bash

SERVICE_NAME="network"
SCRIPT_PATH=$(realpath ./minage.sh)
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
LOG_PATH="/home/pi/network.log"

echo "Creation du service $SERVICE_NAME..."

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Erreur : le script $SCRIPT_PATH n'existe pas !"
    exit 1
fi

if [ -f "$SERVICE_FILE" ]; then
    echo "Le service $SERVICE_NAME existe deja. Voulez-vous le recreer ? (o/n)"
    read -r reponse
    if [ "$reponse" != "o" ]; then
        echo "Annulation."
        exit 0
    fi
    systemctl stop "$SERVICE_NAME"
fi

chmod +x "$SCRIPT_PATH"

bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=a networking service
After=network target

[Service]
ExecStart=$SCRIPT_PATH
WorkingDirectory=$(dirname "$SCRIPT_PATH")
StandardOutput=file:$LOG_PATH
StandardError=file:$LOG_PATH
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
EOF

echo "Service $SERVICE_NAME cree avec succes."

#Recharger systemd, activer et demarrer le service
echo "Activation et demarrage du service..."
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

sleep 2

systemctl status "$SERVICE_NAME" --no-pager
