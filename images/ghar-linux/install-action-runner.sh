#!/bin/bash
chmod +x start-runner.sh;
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ARCH="x64"
    RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
elif [ "$ARCH" = "aarch64" ]; then
    ARCH="arm64"
    RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz"
else
    echo "Unsupported architecture: $ARCH" && exit 1
fi
echo "Runner URL: $RUNNER_URL"
useradd -m runner
cd /home/runner
mkdir actions-runner
cd actions-runner
/home/runner/.pixi/bin/curl -L -O -s $RUNNER_URL
ls -l
tar xzf actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz
rm actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz
chown -R runner /home/runner
/home/runner/actions-runner/bin/installdependencies.sh
