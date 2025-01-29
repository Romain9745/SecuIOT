#!/bin/bash

# Update and upgrade system packages
sudo apt -y update
sudo apt -y upgrade

# Install required dependencies
sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

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