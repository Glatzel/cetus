FROM debian:11 AS base
RUN apt update && apt install -y --no-install-recommends curl ca-certificates build-essential apt-utils
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean
RUN apt autoclean
RUN apt autoremove -y

FROM base AS cloud
ENV PATH="/root/.pixi/bin:${PATH}"
COPY ./pixi-global.toml /root/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update
RUN pixi clean cache -y

FROM base AS local
ARG RUNNER_VERSION
ENV PATH="/home/runner/.pixi/bin:${PATH}"
RUN useradd -m runner

RUN cd /home/runner && mkdir actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh
ADD ./start-runner.sh start-runner.sh
RUN chmod +x start-runner.sh;

RUN rm -rf /var/lib/apt/lists/*
RUN apt clean
RUN apt autoclean
RUN apt autoremove -y

USER runner
# install pixi
COPY --chown=runner:runner ./pixi-global.toml /home/runner/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start-runner.sh"]
