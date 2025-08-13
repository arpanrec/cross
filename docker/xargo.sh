#!/usr/bin/env bash

set -x
set -euo pipefail

# shellcheck disable=SC1091
. lib.sh

main() {
    install_packages ca-certificates curl

    export RUSTUP_HOME=/tmp/rustup
    export CARGO_HOME=/tmp/cargo

    curl --retry 3 -sSfL https://sh.rustup.rs -o rustup-init.sh
    sh rustup-init.sh -y --no-modify-path --profile minimal
    rm rustup-init.sh
    PATH="${CARGO_HOME}/bin:${PATH}" curl -L --proto '=https' --tlsv1.2 -sSf \
        https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    PATH="${CARGO_HOME}/bin:${PATH}" cargo binstall xargo --root /usr/local --force

    rm -r "${RUSTUP_HOME}" "${CARGO_HOME}"

    purge_packages

    rm "${0}"
}

main "${@}"
