FROM debian:11
ENV PATH="~/.pixi/bin:${PATH}"
RUN apt update && apt install -y --no-install-recommends curl ca-certificates && apt-get clean

# Clean up APT cache
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean
RUN apt autoclean
RUN apt autoremove -y

# install pixi
COPY --chown=runner:runner ./pixi-global.toml /home/runner/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update
RUN pixi clean cache -y
