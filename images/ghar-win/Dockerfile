FROM mcr.microsoft.com/windows/servercore:ltsc2025 AS cloud
SHELL ["cmd", "/S", "/C"]
RUN powershell -ExecutionPolicy Bypass -c "irm -useb https://pixi.sh/install.ps1 | iex"
COPY ./pixi-global.toml C:/Users/ContainerUser/.pixi/manifests/pixi-global.toml
RUN pixi global update & pixi clean cache -y
ENTRYPOINT [
  "pwsh",
  "-NoLogo",
  "-NoProfile",
  "-Command",
  "$ErrorActionPreference='Stop'; $PSNativeCommandUseErrorActionPreference=$true;"
]

FROM base AS local

