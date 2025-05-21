FROM ubuntu:latest
ARG RUNNER_VERSION
ENV PATH="/home/runner/.cargo/bin:/home/runner/.pixi/bin:${PATH}"
RUN useradd -m runner

# Update and install common dependencies
COPY ../common/install-deps.sh /tmp/install-deps.sh
RUN bash /tmp/install-deps.sh

USER runner

# install pixi
COPY --chown=runner:runner ./github-action-runner/pixi-global.toml /home/runner/.pixi/manifests/pixi-global.toml
COPY ./common/install-pixi.sh /home/runner/tmp/install-pixi.sh
RUN bash ~/tmp/install-pixi.sh

# install rust
COPY ./common/install-rust.sh /home/runner/tmp/install-rust.sh
RUN bash ~/tmp/install-rust.sh

USER root

# GitHub Actions Runner Installation
RUN cd /home/runner && mkdir actions-runner && cd actions-runner && \
      curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
      tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz&& \
      rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh

# Add and make the start script executable
ADD ./github-action-runner/start-runner.sh start-runner.sh

# make the script executable
RUN chmod +x start-runner.sh;

# Clean up APT cache
RUN rm -rf /var/lib/apt/lists/*

USER runner

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start-runner.sh"]
