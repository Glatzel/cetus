FROM debian:trixie
ARG RUNNER_VERSION
ENV PATH="/home/runner/.pixi/bin:${PATH}"
RUN useradd -m runner
RUN apt update && apt install -y --no-install-recommends curl ca-certificates && apt-get clean
USER runner

# install pixi
COPY --chown=runner:runner ./github-action-runner/pixi-global.toml /home/runner/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash

USER root

# GitHub Actions Runner Installation
RUN cd /home/runner && mkdir actions-runner && cd actions-runner && \
      curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
      tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
      rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
      rm -rf /var/lib/apt/lists/* && \
      apt clean

# install some additional dependencies
RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh

# Add and make the start script executable
ADD ./github-action-runner/start-runner.sh start-runner.sh

# make the script executable
RUN chmod +x start-runner.sh;

USER runner

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start-runner.sh"]
