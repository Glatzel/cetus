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
ARG SIDEFX_CLIENT_ID
ARG SIDEFX_CLIENT_SECRET
ARG HOUDINI_VERSION
RUN useradd -m devuser
ENV PATH="/home/devuser/.pixi/bin:${PATH}"
COPY --from=pixi-base --chown=devuser /home/devuser/.pixi /home/devuser/.pixi
COPY ./start-runner.sh /home/devuser/start-runner.sh
RUN chmod +x /home/devuser/start-runner.sh
RUN chown -R devuser /home/devuser && \
    apt update && \
    apt install -y --no-install-recommends ca-certificates sudo \
    libasound2 libc6 libcups2 libcurl4 libdbus-1-3 libdrm2 libegl1 libexpat1 libfontconfig1 libgcc-s1 libgl1 libglib2.0-0 libglu1-mesa libglx0 libice6 libncursesw6 libnspr4 libnss3 libopengl0 libpci3 libsm6 libxcb-cursor0 \
    && \
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
RUN install_houdini_launcher houdini_launcher && \
    sudo mkdir -p /usr/share/applications

RUN --mount=type=secret,id=sidefx_client_secret \
    echo "client_id=$SIDEFX_CLIENT_ID" > "./setting.ini" && \
    echo "client_secret=${SIDEFX_CLIENT_SECRET}" >> "./setting.ini" && \
    sudo ./houdini_launcher/bin/houdini_installer \
    install \
    --accept-EULA SideFX-2021-10-13 \
    --settings-file ./setting.ini \
    --product Houdini \
    --version $HOUDINI_VERSION \
    --platform linux_x86_64_gcc14.2 && \
    ./houdini_launcher/bin/houdini_installer list && \
    rm ./setting.ini

RUN --mount=type=secret,id=sidefx_client_secret \
    echo "client_id=$SIDEFX_CLIENT_ID" > "./setting.ini" && \
    echo "client_secret=${SIDEFX_CLIENT_SECRET}" >> "./setting.ini" && \
    sudo ./houdini_launcher/bin/houdini_installer \
    install \
    --accept-EULA SideFX-2021-10-13 \
    --settings-file ./setting.ini \
    --product "License Server" \
    --version $HOUDINI_VERSION \
    --platform linux_x86_64_gcc14.2 && \
    rm ./setting.ini
RUN cd hfs$HOUDINI_VERSION && \
    source houdini_setup && \
    cd - && \
    hserver -S localhost && \
    hserver && \
    hserver -l
ENTRYPOINT ["./start-runner.sh"]
