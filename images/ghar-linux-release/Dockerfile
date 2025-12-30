FROM almalinux:8 AS pixi
RUN dnf install -y --setopt=install_weak_deps=False \
        curl \
        ca-certificates
ENV PATH="/root/.pixi/bin:${PATH}"
COPY ./pixi-global.toml /root/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update

FROM almalinux:8 AS release-cloud
ENV PATH="/root/.pixi/bin:${PATH}"
COPY --from pixi /root/.pixi /root/.pixi

FROM almalinux:8 AS release-local
ARG RUNNER_VERSION
ENV PATH="/home/runner/.pixi/bin:${PATH}"
COPY --from pixi /root/.pixi /home/runner/.pixi
RUN useradd -m runner
ADD ./start-runner.sh start-runner.sh
RUN chmod +x start-runner.sh;
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        ARCH="x64" \
        RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        ARCH="arm64" \
        RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    echo "$RUNNER_URL" && \
    cd /home/runner && mkdir actions-runner && cd actions-runner && \
    curl -L -O -s $RUNNER_URL && \
    ls -l && \
    tar xzf actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz && \
    rm actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz && \
    chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh
    rm -rf /var/cache/dnf/* && \
    dnf clean all && \
    dnf autoremove -y
USER runner
ENTRYPOINT ["./start-runner.sh"]
