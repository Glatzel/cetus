# This Dockerfile sets up the image for rattler-build.

FROM almalinux:8 AS pixi-base
ENV PATH="/root/.pixi/bin:${PATH}"
COPY ./pixi-global.toml /root/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update

FROM almalinux:8-minimal AS release-cloud
ENV PATH="/root/.pixi/bin:${PATH}"
COPY --from=pixi-base /root/.pixi /root/.pixi
RUN ln -s /usr/bin/microdnf /usr/bin/dnf
RUN pixi global list
