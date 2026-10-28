# Rust + Cargo profile

Load this profile together with the parent EXACT Coding Predictive TDD skill when the project uses Rust and Cargo.

## Discover project commands first

Read `Cargo.toml` before the first cycle and respect its edition, dependencies, lint configuration, and any `.cargo/config.toml` or `clippy.toml` beside it. Typical gates are:

```bash
cargo test
cargo clippy
```

Not every project declares all of them. Use the full `cargo test` invocation as the complete-suite command. Where a gate has no declared configuration but its tool is installed, invoke it directly; where the tool is absent, skip it rather than inventing an invocation.

Do not add dependencies the project has not declared, and do not relax a lint level in `Cargo.toml` or the configuration files to make a check pass.

## Source and test layout

Follow the crate layout already established by the project. In a conventional library-plus-binary crate:

- domain code lives in the library, `src/lib.rs` and the modules it declares
- the binary in `src/main.rs` is a thin adapter over the library
- unit tests live in a `#[cfg(test)] mod tests` module beside the code they test, importing it with `use super::*;`
- tests that exercise only the public API may live under `tests/`

Keep test-only helpers inside test modules. Do not make an item `pub` solely so a test can reach it; a unit test in the same module already can.

## Test-list convention

Represent future examples as `#[test]` functions marked `#[ignore]`. Activate exactly one behavior per cycle by removing that attribute from the test.

For the up-front Test List phase, create the complete test module with inactive entries only:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[ignore = "TODO: expected result from the specification"]
    fn handles_the_first_behaviour() {
        // Add the observation when this behavior enters Red.
    }

    #[test]
    #[ignore = "TODO: next expected result from the specification"]
    fn handles_the_next_behaviour() {
        // Add the observation when this behavior enters Red.
    }
}
```

Place the verification tests after all driving tests, in a nested module named exactly `verification` inside the test module. The workflow refers to the group by this name; do not translate or extend it:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    // driving tests as above

    mod verification {
        use super::*;

        #[test]
        #[ignore = "TODO: combination result from the specification"]
        fn handles_the_combination() {
            // Add the observation when this test is activated.
        }
    }
}
```

Moving a test into the verification group means moving its ignored function into that module before activating it.

Use `assert_eq!`, `assert!` and `assert_ne!`, and `#[should_panic(expected = "...")]` only where a panic is the specified behavior; prefer asserting on a returned `Result` or `Option`. Keep every future behavior marked; do not use commented-out tests, an empty test without the marker, or name filters as the test list.

## Interpret RED correctly

Inspect Cargo's actual result before comparing it with the prediction:

1. distinguish a compile error from a test failure
2. distinguish an unresolved name, a missing method or a type mismatch from an assertion failure
3. inspect the assertion's `left` and `right` values and any panic message
4. record tests passed, failed, and ignored for every test binary Cargo ran

A missing function, method, or type fails during compilation, and Cargo then runs no test at all; do not call that an assertion failure. A test binary that fails stops Cargo from running the later ones, so confirm which binaries actually ran before reading a count. It is a valid RED only when it is the intended failure for the current baby step. Otherwise revert and choose a smaller or corrected step.

A compile error is commonly the first step of a two-step RED: introduce the signature, return an intentionally wrong value or call `todo!()` only long enough to reach the behavioral failure, and then make it fail for the predicted reason. When an activated example is already satisfied by an earlier generalization, follow the already-green exception in the parent skill: predict the passing result, run the suite, record that no production change is needed, and continue without manufacturing a failure.

## Rust-oriented GREEN progression

Let the implementation emerge one active example at a time. Typical small steps include:

1. a function, type, or method signature sufficient to compile
2. an intentionally wrong result sufficient to reach behavioral RED
3. a hardcoded return for the first GREEN
4. use of an input parameter
5. a narrow conditional or `match` arm
6. named domain constants, types, or extracted functions when another example forces them
7. an iterator chain or general expression only when demanded by active behavior
8. explicit validation and error types only when required by the specification

Do not jump to an iterator chain, a trait, or a generic parameter because Rust makes it expressive to write. Keep domain names even when a parameter is temporarily unused; prefix it with an underscore rather than renaming it away. Do not add meaningless reads, branches, or statements to appease the compiler or clippy.

The compiler checks types and ownership before any test runs, so let it guide the shape of a call, and treat a borrow-checker error as information about the design rather than something to silence with a clone. Do not reach for `unwrap()` in production code where the specification describes an error case.

## Rust-oriented SRP review

Apply the parent Predictive TDD skill's Single Responsibility Principle at Rust boundaries. Keep domain decisions in the library and separate from adapters such as argument parsing, JSON serialization with `serde`, console I/O, filesystem access, and persistence in the binary. Prefer a cohesive function, type, or module whose name states one responsibility; extract a collaborator when separate concerns would change for separate reasons. Prefer a plain function to a type with methods when there is no state to hold, prefer an enum to a flag when the domain names its cases, and do not introduce a trait, generic, or design pattern without a concrete responsibility in the current code.

## Clippy and quality checks

When clippy is available, use the project's declared configuration, commonly:

```bash
cargo clippy
```

Clippy findings are evidence for the Four Rules review, not permission to change observable behavior. Inspect the configured lints and their thresholds before treating a report as a failing smell. Allow concrete literals in test examples when they express specification inputs and outputs; prefer named domain constants in production code when literals duplicate knowledge.

Do not weaken lints globally in `Cargo.toml` or with a crate-level `#![allow(...)]`, and do not silence a finding with a broad `#[allow]` where a narrow, item-level one states the reason. Use `cargo fmt` where the project formats its code.

## Predictive phase gate

Before every deterministic check, state a falsifiable expectation and run the check immediately. Use the smallest relevant `cargo test <filter>` invocation during diagnosis and the complete suite for cycle closure:

```bash
cargo test
```

- **RED:** continue only when the active behavior fails for the predicted reason; investigate a mismatch rather than changing production behavior.
- **GREEN:** retain the change only when the complete suite passes.
- **REFACTOR:** run the complete suite and applicable quality gates; retain a structural trial only when all pass and intent improves, otherwise narrowly undo that trial.

Do not create method commits or use hard resets as phase transitions. Before completion, run every applicable project-defined quality gate in the established order. Record Cargo's exact counts per test binary and distinguish failures, compile errors, and ignored tests.
