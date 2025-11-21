#!/usr/bin/env bash
set -e

IMAGE_NAME="iic-osic-tools_xserver"
WORKDIR="/workspaces/$(basename "$(pwd)")"

echo "[run.sh] Starting…"

################################################################################
# Detect Platform
################################################################################

is_wsl=false
is_macos=false
is_linux=false

if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    is_wsl=true
elif [[ "$OSTYPE" == "darwin"* ]]; then
    is_macos=true
else
    is_linux=true
fi

################################################################################
# Build Image (if missing)
################################################################################

if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "[run.sh] Image '$IMAGE_NAME' not found. Building…"
    docker build -t "$IMAGE_NAME" .
fi

################################################################################
# Base Args
################################################################################

docker_args=(
    "--rm"
    "-it"
    "--user" "1000:1000"
    "-e" "SHELL=/bin/bash"
    "-v" "$(pwd):$WORKDIR"
    "-w" "$WORKDIR"
)

################################################################################
# Native Linux Config (X11)
################################################################################

elif $is_linux; then
    echo "[run.sh] Detected native Linux environment"

    docker_args+=(
        "-e" "DISPLAY=$DISPLAY"
        "-v" "/tmp/.X11-unix:/tmp/.X11-unix:rw"
    )

################################################################################
# macOS (XQuartz for GUI)
################################################################################

elif $is_macos; then
    echo "[run.sh] Detected macOS environment"

    # Requires: brew install --cask xquartz
    # And enable: xhost +localhost

    docker_args+=(
        "-e" "DISPLAY=host.docker.internal:0"
    )
fi

################################################################################
# Run Container
################################################################################

echo "[run.sh] Launching container…"

exec docker run "${docker_args[@]}" "$IMAGE_NAME"
