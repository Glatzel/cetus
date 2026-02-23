FROM almalinux:8 AS pixi-base
RUN useradd -m runner
USER runner
ENV PATH="/home/runner/.pixi/bin:${PATH}"
COPY --chown=runner ./pixi-global.toml /home/runner/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update
