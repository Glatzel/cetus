FROM debian:trixie
ARG RUNNER_VERSION
ENV PATH="/home/runner/.cargo/bin:/home/runner/.pixi/bin:${PATH}"
RUN useradd -m runner

USER runner

# install pixi
RUN curl -fsSL https://pixi.sh/install.sh | bash
COPY --chown=runner:runner ./github-action-runner/pixi-global.toml /home/runner/.pixi/manifests/pixi-global.toml
RUN pixi global update base-ci
RUN pixi clean cache -y

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --profile minimal --default-toolchain stable
RUN ~/.cargo/bin/rustup component add clippy --toolchain stable
RUN ~/.cargo/bin/rustup toolchain install nightly --profile=minimal
RUN ~/.cargo/bin/rustup component add rustfmt --toolchain nightly
RUN ~/.cargo/bin/rustup default stable

USER root

# GitHub Actions Runner Installation
RUN cd /home/runner && mkdir actions-runner && cd actions-runner && \
      curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
      tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
      rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh

# Add and make the start script executable
ADD ./github-action-runner/start-runner.sh start-runner.sh

# make the script executable
RUN chmod +x start-runner.sh;

# Clean up APT cache
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean

USER runner

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start-runner.sh"]
