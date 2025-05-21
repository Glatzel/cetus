#!/bin/sh
set -e

curl https://sh.rustup.rs -sSf | bash -s -- -y --profile minimal --default-toolchain stable
~/.cargo/bin/rustup component add clippy --toolchain stable
~/.cargo/bin/rustup toolchain install nightly --profile=minimal
~/.cargo/bin/rustup component add rustfmt --toolchain nightly
~/.cargo/bin/rustup default stable
