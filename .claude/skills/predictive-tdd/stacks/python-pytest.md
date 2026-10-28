# Python + pytest profile

Load this profile together with the parent EXACT Coding Predictive TDD skill when the project uses Python and pytest.

## Discover project commands first

Read `pyproject.toml` before the first cycle and respect its Python requirement, dependencies, test configuration, and tool settings. Use the project's environment manager and declared commands. Typical gates are:

```bash
pytest
ruff check src/
```

Not every project declares all of them. Use the full `pytest` invocation as the complete-suite command. Where a gate has no declared command but its tool is installed, invoke it directly; where the tool is absent, skip it rather than inventing an invocation.

When the project uses a virtual environment, run the tools from it rather than from the system interpreter. Do not install packages the project has not declared, and do not silently relax a version constraint to make a check pass.

## Source and test layout

Follow the package and module layout already established by the project. In a conventional `src`-layout project:

- production code lives under `src/`
- tests live under `tests/`, in files named `test_*.py`
- a test module mirrors the module under test

Import production modules the way the project's test configuration already makes possible. Do not add `sys.path` manipulation to test files, and do not restructure existing packages as unrelated cleanup.

## Test-list convention

Represent future examples as pytest tests marked `@pytest.mark.skip`. Activate exactly one behavior per cycle by removing that marker from the test.

For the up-front Test List phase, create the complete test file with inactive entries only:

```python
import pytest


@pytest.mark.skip(reason="TODO: expected result from the specification")
def test_handles_the_first_behaviour():
    """Add the observation when this behavior enters Red."""


@pytest.mark.skip(reason="TODO: next expected result from the specification")
def test_handles_the_next_behaviour():
    """Add the observation when this behavior enters Red."""
```

Place the verification tests after all driving tests, as methods of a class named exactly `TestVerification`. The workflow refers to the group by this name; do not translate or extend it:

```python
class TestVerification:
    @pytest.mark.skip(reason="TODO: combination result from the specification")
    def test_handles_the_combination(self):
        """Add the observation when this test is activated."""
```

Moving a test into the verification group means moving its marked function into that class, as a method, before activating it.

Use plain `assert` statements and `pytest.raises` for expected exceptions. Keep every future behavior marked; do not use commented-out tests, a bare `pass` without a marker, or name filters as the test list.

## Interpret RED correctly

Inspect pytest's actual result before comparing it with the prediction:

1. distinguish collection errors from test failures
2. distinguish import and attribute resolution errors from assertion failures
3. inspect the assertion's expected and actual values and any exception type
4. record tests passed, failed, errored, skipped, and xfailed

A missing module, function, or method commonly fails during collection with `ModuleNotFoundError`, `ImportError`, or `AttributeError`; do not call that an assertion failure. Because a collection error can abort a whole file, confirm which tests actually ran before reading a count. It is a valid RED only when it is the intended failure for the current baby step. Otherwise revert and choose a smaller or corrected step.

When an exception is the specified observable behavior, use `pytest.raises` and verify its type. When an activated example is already satisfied by an earlier generalization, follow the already-green exception in the parent skill: predict the passing result, run the suite, record that no production change is needed, and continue without manufacturing a failure.

## Python-oriented GREEN progression

Let the implementation emerge one active example at a time. Typical small steps include:

1. a module, function, or method signature sufficient to import
2. an intentionally wrong result or exception sufficient to reach behavioral RED
3. a hardcoded return for the first GREEN
4. use of an input parameter
5. a narrow conditional
6. named domain constants or extracted functions when another example forces them
7. a comprehension, generator, or general expression only when demanded by active behavior
8. explicit validation only when required by the specification

Do not jump to a comprehension or a library call because Python makes it short to write. Keep domain names even when a parameter is temporarily unused. Do not add meaningless reads, branches, or statements to appease static analysis.

Dynamic typing means a wrong call signature surfaces at runtime rather than at compile time, so read the failure rather than assuming the shape of the call was checked for you. Where the project declares type annotations or runs a type checker, treat that check as a signal separate from the test run.

## Python-oriented SRP review

Apply the parent Predictive TDD skill's Single Responsibility Principle at Python boundaries. Keep domain decisions separate from adapters such as argument parsing, JSON serialization, console or HTTP transport, filesystem access, and persistence. Prefer a cohesive function, class, or module whose name states one responsibility; extract a collaborator when separate concerns would change for separate reasons. Prefer a plain function to a class when there is no state to hold, keep pytest fixtures in test code rather than production abstractions, and do not introduce a class, protocol, or design pattern without a concrete responsibility in the current code.

## Ruff and quality checks

When ruff is configured, use the project's declared invocation, commonly:

```bash
ruff check src/
```

Ruff findings are evidence for the Four Rules review, not permission to change observable behavior. Inspect the configured rule selection and its thresholds before treating a report as a failing smell. Allow concrete literals in test examples when they express specification inputs and outputs; prefer named domain constants in production code when literals duplicate knowledge.

Keep test-specific concessions scoped to test files through the project's per-file mechanism. Do not weaken production rules globally, and do not silence a finding with a blanket `# noqa` where a narrow, rule-specific suppression states the reason. Use configured formatter, type-checker, or coverage commands where applicable.

## Predictive phase gate

Before every deterministic check, state a falsifiable expectation and run the check immediately. Use the smallest relevant pytest invocation during diagnosis and the complete suite for cycle closure:

```bash
pytest
```

- **RED:** continue only when the active behavior fails for the predicted reason; investigate a mismatch rather than changing production behavior.
- **GREEN:** retain the change only when the complete suite passes.
- **REFACTOR:** run the complete suite and applicable quality gates; retain a structural trial only when all pass and intent improves, otherwise narrowly undo that trial.

Do not create method commits or use hard resets as phase transitions. Before completion, run every applicable project-defined quality gate in the established order. Record pytest's exact counts and distinguish failures, errors, skips, and xfails.
