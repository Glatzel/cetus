FROM almalinux:8 AS pixi-base
RUN useradd -m runner
USER runner
ENV PATH="/home/runner/.pixi/bin:${PATH}"
COPY --chown=runner ./pixi-global.toml /home/runner/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update

FROM debian:13 AS msb
RUN useradd -m runner
ENV PATH="/home/runner/.pixi/bin:${PATH}"
COPY --from=pixi-base --chown=runner /home/runner/.pixi /home/runner/.pixi
COPY ./start-runner.sh /home/runner/start-runner.sh
RUN chmod +x /home/runner/start-runner.sh
RUN chown -R runner ~runner && \
    usermod -aG sudo runner && \
    apt update && \
    apt install -y --no-install-recommends ca-certificates \
    /home/runner/.pixi/envs/runner/bin/installdependencies.sh && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    apt autoclean && \
    apt autoremove -y
WORKDIR /home/runner
USER runner
RUN pixi global list
ENTRYPOINT ["./start-runner.sh"]
