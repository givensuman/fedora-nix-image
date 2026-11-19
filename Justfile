set shell := ["bash", "-euo", "pipefail", "-c"]

export DOCKER_HOST := env("DOCKER_HOST", "unix://" + env("XDG_RUNTIME_DIR", "/run/user/1000") + "/podman/podman.sock")

default:
    @just --list

# Lint the Containerfile and shell scripts
lint:
    hadolint Containerfile
    shellcheck apply.sh

# Build the image
build:
    podman build -t fedora-nix-image:dev .

# Run GitHub workflows
ci:
    systemctl --user start podman.socket
    act pull_request -j build
