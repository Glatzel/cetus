FROM mcr.microsoft.com/windows/servercore:ltsc2025
SHELL ["cmd", "/S", "/C"]
RUN powershell -ExecutionPolicy Bypass -c "irm -useb https://pixi.sh/install.ps1 | iex"
COPY ./pixi-global.toml C:/Users/ContainerAdministrator/.pixi/manifests/pixi-global.toml
RUN pixi global update & pixi clean cache -y
SHELL ["pwsh", "-Command","$ErrorActionPreference='Stop'; $PSNativeCommandUseErrorActionPreference=$true;"]
ENTRYPOINT ["pwsh", "-Command","$ErrorActionPreference='Stop'; $PSNativeCommandUseErrorActionPreference=$true;"]
ADD ./start-runner.ps1 .
ENTRYPOINT ["pwsh", "./start-runner.ps1"]
