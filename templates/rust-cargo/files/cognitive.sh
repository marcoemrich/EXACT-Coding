#!/usr/bin/env bash
# Cognitive and McCabe complexity per production function, highest first.
#
# rust-code-analysis reports every function in a file, test functions included,
# and does not mark which module they belong to. Inline tests sit below the
# file's `#[cfg(test)]` line by convention, so functions from that line on are
# left out.
set -euo pipefail
cd "$(dirname "$0")"

RCA=target/tools/bin/rust-code-analysis-cli
if [ ! -x "$RCA" ]; then
  echo "rust-code-analysis-cli is not installed (cargo clean removes it)." >&2
  echo "Reinstall with: templates/rust-cargo/install.sh" >&2
  exit 1
fi

printf 'cognitive\tmccabe\tfunction\n'
find src -name '*.rs' | sort | while read -r file; do
  cutoff=$(grep -n -m1 '^[[:space:]]*#\[cfg(test)\]' "$file" | cut -d: -f1 || true)
  "$RCA" -m -O json -p "$file" | jq -r --arg file "$file" --argjson cutoff "${cutoff:-0}" '
    .. | objects | select(.kind? == "function")
    | select($cutoff == 0 or .start_line < $cutoff)
    | [.metrics.cognitive.sum, .metrics.cyclomatic.sum, "\($file):\(.start_line) \(.name)"]
    | @tsv'
done | sort -t $'\t' -k1,1nr -k2,2nr
