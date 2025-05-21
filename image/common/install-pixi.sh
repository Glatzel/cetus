#!/bin/sh
set -e

curl -fsSL https://pixi.sh/install.sh | bash
pixi global update
pixi clean cache -y
