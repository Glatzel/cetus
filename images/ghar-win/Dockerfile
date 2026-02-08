FROM mcr.microsoft.com/windows/servercore:ltsc2025 AS cloud
SHELL ["cmd", "/S", "/C"]
RUN powershell -ExecutionPolicy Bypass -c "irm -useb https://pixi.sh/install.ps1 | iex"
COPY ./pixi-global.toml C:/Users/ContainerUser/.pixi/manifests/pixi-global.toml
RUN pixi global update & pixi clean cache -y
ENTRYPOINT ["pwsh", "-Command","$ErrorActionPreference='Stop'; $PSNativeCommandUseErrorActionPreference=$true;"]

FROM cloud AS local
ARG RUNNER_VERSION
RUN Invoke-WebRequest -Uri "https://github.com/actions/runner/releases/download/v$env:RUNNER_VERSION/actions-runner-win-x64-$env:RUNNER_VERSION.zip" -OutFile "actions-runner.zip"; \
    Expand-Archive -Path ".\\actions-runner.zip" -DestinationPath '.'; \
    Remove-Item ".\\actions-runner.zip" -Force
ADD ./start-runner.ps1 .
ENTRYPOINT ["pwsh", "./start-runner.ps1"]
