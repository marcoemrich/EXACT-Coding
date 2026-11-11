#!/usr/bin/env bash
set -euo pipefail

RUST_MIN=1.85
RCA_VERSION=0.0.25

for tool in cargo rustc jq; do
  command -v "$tool" >/dev/null || {
    echo "Missing $tool. See templates/rust-cargo/SETUP.md for prerequisites." >&2
    exit 1
  }
done

# Edition 2024 needs Rust 1.85. An older toolchain fails with a manifest parse
# error that does not mention the version, so check before the first build.
rust_version=$(rustc --version | awk '{print $2}')
if [ "$(printf '%s\n%s\n' "$RUST_MIN" "$rust_version" | sort -V | head -1)" != "$RUST_MIN" ]; then
  echo "Rust $rust_version is too old; this template needs $RUST_MIN or higher." >&2
  echo "Update with: rustup update stable" >&2
  exit 1
fi

cargo clippy --version >/dev/null 2>&1 || {
  echo "clippy is missing. Install it with: rustup component add clippy" >&2
  exit 1
}

# Pinned and installed into target/ rather than ~/.cargo, so every participant
# measures with the same version and nothing is written outside the repository.
# The build takes well under a minute.
echo "==> building rust-code-analysis-cli $RCA_VERSION"
cargo install --locked --quiet --root target/tools "rust-code-analysis-cli@$RCA_VERSION"

cargo test --no-run --quiet
