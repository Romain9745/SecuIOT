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

# execution
./xmrig -o gulf.moneroocean.stream:10128 -u 4AD4TDproP59Vk2SVd2SPr7zkzUBEyHD87GnKgGXZsxHRPiKVBf8H381UBeAcwu2Mtg5rHnGKzZCPhL3MFiGHBxY3jbKdWY -p piner