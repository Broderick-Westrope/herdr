# Recipes for the Broderick-Westrope fork. Kept out of the upstream justfile to avoid rebase conflicts.

# Build a release binary and install it ahead of Homebrew's herdr, e.g. `just install-fork`
[unix]
install-fork dest="~/.local/bin":
    #!/usr/bin/env bash
    set -euo pipefail
    zig="${ZIG:-}"
    if [ -z "$zig" ]; then
        zig="$(nix --extra-experimental-features 'nix-command flakes' build --no-link --print-out-paths --inputs-from . nixpkgs#zig_0_16)/bin/zig"
    fi
    ZIG="$zig" cargo build --release --locked
    dest="{{dest}}"
    dest="${dest/#\~/$HOME}"
    mkdir -p "$dest"
    install -m 755 target/release/herdr "$dest/herdr"
    echo "installed $("$dest/herdr" --version) at $dest/herdr ($(git rev-parse --short HEAD))"
    echo "the running server keeps the old binary until it is restarted or handed off"
