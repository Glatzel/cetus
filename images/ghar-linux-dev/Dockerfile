# This Dockerfile sets up the image for docker with github action runner installed.
# Use this image for generic development.

FROM almalinux:8 AS pixi-base
RUN useradd -m devuser
USER devuser
ENV PATH="/home/devuser/.pixi/bin:${PATH}"
COPY --chown=devuser ./pixi-global.toml /home/devuser/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update

FROM ubuntu:26.04 AS dev-local
RUN useradd -m devuser
ENV PATH="/home/devuser/.pixi/bin:${PATH}"
COPY --from=pixi-base --chown=devuser /home/devuser/.pixi /home/devuser/.pixi
COPY ./start-runner.sh /home/devuser/start-runner.sh
RUN chmod +x /home/devuser/start-runner.sh
RUN chown -R devuser /home/devuser && \
    apt update && \
    apt install -y --no-install-recommends ca-certificates sudo && \
    usermod -aG sudo devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devuser && \
    chmod 0440 /etc/sudoers.d/devuser && \
    /home/devuser/.pixi/envs/runner/bin/installdependencies.sh && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    apt autoclean && \
    apt autoremove -y
WORKDIR /home/devuser
USER devuser
RUN pixi global list
ENTRYPOINT ["./start-runner.sh"]
