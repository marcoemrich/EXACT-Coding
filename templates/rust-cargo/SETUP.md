# Rust + Cargo

## Prerequisites

- Rust 1.85 or higher (`rustc --version`), with Cargo (`cargo --version`)
- Clippy (`cargo clippy --version`)
- jq (`jq --version`), for the complexity report

Install Rust with [rustup](https://rustup.rs). Its default profile includes
Clippy; on a minimal profile add it with `rustup component add clippy`.
Distribution packages of Rust are often older than 1.85, which this template
needs for edition 2024. Install jq from your package manager
(`sudo apt install jq`, `brew install jq`).

The dev container does not ship a Rust toolchain. Use a local installation for
this stack.

## Install

```bash
./setup.sh rust-cargo
```

Setup builds `rust-code-analysis-cli` at a pinned version into `target/tools/`,
so every participant measures with the same tool and nothing is installed
outside the repository. The build needs network access to crates.io and takes
well under a minute. `cargo clean` removes it as well; run
`templates/rust-cargo/install.sh` to get it back.

## Commands

| Purpose | Command |
|---|---|
| Run the suite | `cargo test` |
| Tests matching a name | `cargo test adds_two` |
| Lint and smell report | `cargo clippy --all-targets` |
| Cognitive complexity report | `./cognitive.sh` |

Your IDE's test runner works as well (RustRover, or VS Code with
rust-analyzer).

## Expected output

`./setup.sh` ends with the example test:

```
running 1 test
test example::tests::adds_two_numbers ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

Cargo also runs the (empty) doc tests and reports `0 passed` for them. Once you
have worked through exercises you will see more tests than this. What matters
is that the suite passes and no test fails.

## Notes for the workflow

- The crate is a library. Exercise code lives in modules declared in
  `src/lib.rs`; unit tests live in a `#[cfg(test)] mod tests` block at the end
  of the file they test.
- Inactive test-list entries are `#[ignore]`.
- `Cargo.toml` and `clippy.toml` carry the smells for the end-refactor pass.
  `./cognitive.sh` reports cognitive and McCabe complexity per production
  function, so those scores are measurements, not smells. It leaves out
  everything from a file's `#[cfg(test)]` line on.
- Clippy reports, it does not gate the suite. The refactor decision stays with
  you and the agent.
