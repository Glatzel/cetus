FROM almalinux:8 AS pixi-base
ENV PATH="/root/.pixi/bin:${PATH}"
COPY ./pixi-global.toml /root/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update

FROM almalinux:8 AS release-cloud
ENV PATH="/root/.pixi/bin:${PATH}"
COPY --from=pixi-base /root/.pixi /root/.pixi
RUN pixi global list
