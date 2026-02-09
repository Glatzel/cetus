docker buildx build `
    --load `
    --platform 'linux/amd64,linux/arm64' `
    -f pixi-base.Dockerfile `
    .
