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

apt-get clean
dpkg --get-selections
