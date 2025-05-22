#!/bin/sh
set -e

apt-get update
# Update and install common dependencies
apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    libsqlite3-dev \
    wget

# install pwsh
wget -q https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell

apt-get clean
dpkg --get-selections
