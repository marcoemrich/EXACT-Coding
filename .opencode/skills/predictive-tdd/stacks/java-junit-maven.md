# Java + JUnit 5 + Maven profile

Load this profile together with the parent EXACT Coding Predictive TDD skill when the project uses Java, JUnit 5, and Maven.

## Discover project commands first

Read `pom.xml` before the first cycle. Respect its Java release, dependencies, plugins, source layout, and existing test conventions. Use the Maven wrapper when present; otherwise use `mvn`.

Typical gates are:

```bash
mvn test
mvn pmd:check
```

Only run configured or available gates. Do not invent plugins or silently change the build to obtain a preferred check. Use `mvn test` as the full-suite command unless the project defines another command used by CI.

## Source and test layout

Follow the package and module layout already established by the project. In a conventional single-module Maven project:

- production code lives under `src/main/java/`
- tests live under `src/test/java/`
- `<Feature>Test.java` mirrors the package of the class under test

Use the default package only when the project already does. Do not move existing code into packages as unrelated cleanup.

## Test-list convention

Represent future examples as JUnit 5 tests annotated with `@Disabled`. Activate exactly one behavior per cycle by removing `@Disabled` from that test.

For the up-front Test List phase, create the complete test file with inactive entries only:

```java
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

class FeatureTest {
    @Disabled("TODO: expected result from the specification")
    @Test
    void handlesTheFirstBehaviour() {
        // Add the observation when this behavior enters Red.
    }

    @Disabled("TODO: next expected result from the specification")
    @Test
    void handlesTheNextBehaviour() {
        // Add the observation when this behavior enters Red.
    }
}
```

Place the verification tests after all driving tests, inside a nested class named exactly `Verification`. The workflow refers to the group by this name; do not translate or extend it:

```java
import org.junit.jupiter.api.Nested;

class FeatureTest {
    // driving tests as above

    @Nested
    class Verification {
        @Disabled("TODO: combination result from the specification")
        @Test
        void handlesTheCombination() {
            // Add the observation when this test is activated.
        }
    }
}
```

Moving a test into the verification group means moving its disabled method into that nested class before activating it.

Use JUnit 5 annotations and assertions. Keep every future behavior disabled; do not use commented-out tests or test-name filters as the test list.

## Interpret RED correctly

Inspect Maven's actual result before comparing it with the prediction:

1. distinguish production compilation from `testCompile`
2. distinguish symbol-resolution errors from JUnit assertion failures
3. inspect expected exceptions, expected and actual values, and failure messages
4. record tests run, failed, errored, and skipped

A missing class or method commonly fails in `testCompile` with `cannot find symbol`; do not call that an assertion failure. It is a valid RED only when it is the intended failure for the current baby step. Otherwise revert and choose a smaller or corrected step.

When an exception is the specified observable behavior, use `assertThrows` and verify its type. When an activated example is already satisfied by an earlier generalization, follow the already-green exception in the parent skill: predict the passing result, run the suite, record that no production change is needed, and continue without manufacturing a failure.

## Java-oriented GREEN progression

Let the implementation emerge one active example at a time. Typical small steps include:

1. a class and method signature sufficient to compile
2. an intentionally wrong result or exception sufficient to reach behavioral RED
3. a hardcoded return for the first GREEN
4. use of an input parameter
5. a narrow conditional
6. named domain constants or extracted methods when another example forces them
7. a general expression, collection operation, or polymorphic design only when demanded by active behavior
8. explicit validation only when required by the specification

Do not jump to a final abstraction because Java makes scaffolding visible. Keep domain names even when a parameter is temporarily unused. Do not add meaningless reads or branches to appease static analysis.

## Java-oriented SRP review

Apply the parent Predictive TDD skill's Single Responsibility Principle at Java boundaries. Keep domain decisions separate from adapters such as argument or JSON parsing, console or HTTP transport, filesystem access, and persistence. Prefer a cohesive method or class whose name states one responsibility; extract a collaborator when separate concerns would change for separate reasons. Keep JUnit setup and fixtures in test code rather than production abstractions, and do not introduce an interface, class, or design pattern without a concrete responsibility in the current code.

## PMD and quality checks

When PMD is configured, use the project's declared PMD goal, commonly:

```bash
mvn pmd:check
```

PMD findings are evidence for the Four Rules review, not permission to change observable behavior. Inspect configured complexity thresholds before treating a report as a failing smell. Keep test-specific concessions scoped to tests and do not weaken production rules globally for a temporary GREEN.

Use configured Checkstyle, SpotBugs, formatter, or module-specific verification goals where applicable.

## Predictive phase gate

Before every deterministic check, state a falsifiable expectation and run the check immediately. Use the smallest relevant Maven invocation during diagnosis and the complete suite for cycle closure:

```bash
mvn test
```

- **RED:** continue only when the active behavior fails for the predicted reason; investigate a mismatch rather than changing production behavior.
- **GREEN:** retain the change only when the complete suite passes.
- **REFACTOR:** run the complete suite and applicable quality gates; retain a structural trial only when all pass and intent improves, otherwise narrowly undo that trial.

Do not create method commits or use hard resets as phase transitions. Before completion, run every applicable project-defined quality gate in the established order. Record Maven's exact test counts and distinguish failures, errors, and skipped tests.
