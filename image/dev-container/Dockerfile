FROM ubuntu:latest
ARG RUNNER_VERSION
ENV PATH="/root/.cargo/bin:/root/.pixi/bin:${PATH}"

# Update and install common dependencies
COPY ./common/install-deps.sh /tmp/install-deps.sh
RUN bash /tmp/install-deps.sh

# install pixi
COPY ./dev-container/pixi-global.toml /root/.pixi/manifests/pixi-global.toml
COPY ./common/install-pixi.sh /tmp/install-pixi.sh
RUN bash /tmp/install-pixi.sh

#install rust
COPY ./common/install-rust.sh /tmp/install-rust.sh
RUN bash /tmp/install-rust.sh

#config starship
COPY ./common/starship.toml /root/.config/starship.toml
RUN mkdir -p ~/.config/powershell && echo 'Invoke-Expression (&starship init powershell)' >> ~/.config/powershell/Microsoft.PowerShell_profile.ps1
RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Clean up APT cache
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean