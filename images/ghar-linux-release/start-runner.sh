#!/bin/bash
set -e
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}
log "Runner container starting..."
log "PATH: ${PATH}"
log "PWD: ${PWD}"
GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY
GH_TOKEN=$GH_TOKEN
EPHEMERAL=${EPHEMERAL:-false}
RUNNER_LABELS=${RUNNER_LABELS:-self-hosted}
log "Repository: ${GH_OWNER}/${GH_REPOSITORY}"
log "Ephemeral mode: ${EPHEMERAL}"
log "Runner labels: ${RUNNER_LABELS}"

RUNNER_SUFFIX=$(head -c 256 /dev/urandom | tr -dc 'a-z0-9' | head -c 8)
RUNNER_NAME="dockerNode-${RUNNER_SUFFIX}"
log "Generated runner name: ${RUNNER_NAME}"
log "Requesting GitHub runner registration token..."
REG_TOKEN=$(curl -sX POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${GH_TOKEN}" \
    https://api.github.com/repos/${GH_OWNER}/${GH_REPOSITORY}/actions/runners/registration-token \
    | jq .token --raw-output)
if [ -z "$REG_TOKEN" ]; then
    log "ERROR: Failed to obtain registration token"
    exit 1
fi
log "Registration token received"
cd .pixi/envs/runner
log "Configuring GitHub Actions runner..."
EPHEMERAL_FLAG=""
if [ "${EPHEMERAL}" = "true" ]; then
    EPHEMERAL_FLAG="--ephemeral"
fi
./config.sh \
    --unattended \
    --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} \
    --token ${REG_TOKEN} \
    --name ${RUNNER_NAME} \
    --labels ${RUNNER_LABELS} \
    ${EPHEMERAL_FLAG} \
log "Runner successfully configured"
cleanup() {
    log "Removing runner from GitHub..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
    log "Runner removed"
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM
log "Starting GitHub Actions runner..."
if [ "${EPHEMERAL}" = "true" ]; then
    ./run.sh
    log "Ephemeral runner finished job, exiting..."
    exit 0
else
    ./run.sh & wait $!
fi
