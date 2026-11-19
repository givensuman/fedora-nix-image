#!/usr/bin/env bash

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

dnf5 -y install nix nix-daemon
cp -a "${here}/files/." /

install -Dm0644 "${here}/nix.pp" /usr/share/selinux/packages/nix.pp
semodule -i /usr/share/selinux/packages/nix.pp

systemctl enable nix-directory.service nix.mount nix-daemon.socket
dnf5 clean all
