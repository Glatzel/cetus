#!/bin/bash
set -e
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}
log "Runner container starting..."
log "PATH: ${PATH}"
log "PWD: ${PWD}"
GH_OWNER=${1:?GH_OWNER required}
GH_REPOSITORY=${2:?GH_REPOSITORY required}
GH_TOKEN=${3:?GH_TOKEN required}
EPHEMERAL=${EPHEMERAL:-false}
RUNNER_LABELS=${RUNNER_LABELS:-self-hosted}
EPHEMERAL_FLAG=""
if [[ "${EPHEMERAL,,}" != "false" ]]; then
    EPHEMERAL="true"
    EPHEMERAL_FLAG="--ephemeral"
fi
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
if [ -f ".runner" ]; then
    log "Found leftover local runner state from a previous container, clearing it..."
    rm -f .runner .credentials .credentials_rsaparams .setup_info
fi
log "Configuring GitHub Actions runner..."
./config.sh \
    --unattended \
    --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} \
    --token ${REG_TOKEN} \
    --name ${RUNNER_NAME} \
    --labels ${RUNNER_LABELS} \
    ${EPHEMERAL_FLAG}
log "Runner successfully configured"
CLEANED_UP=0
cleanup() {
    if [ "${CLEANED_UP}" -eq 1 ]; then
        return 0
    fi
    CLEANED_UP=1

    local retries=5
    local delay=10
    log "Removing runner from GitHub..."
    for i in $(seq 1 "$retries"); do
        if ./config.sh remove --unattended --token "${REG_TOKEN}"; then
            log "Runner removed"
            return 0
        fi
        log "Runner removal failed (attempt ${i}/${retries}), retrying in ${delay}s..."
        sleep "${delay}"
    done
    log "Failed to remove runner after ${retries} attempts"
    return 1
}
trap cleanup EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM
log "Starting GitHub Actions runner..."
if [ "${EPHEMERAL_FLAG}" = "--ephemeral" ]; then
    ./run.sh
    log "Ephemeral runner finished job, exiting..."
    exit 0
else
    ./run.sh & wait $!
fi
