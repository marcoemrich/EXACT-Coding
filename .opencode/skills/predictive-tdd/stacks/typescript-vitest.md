# TypeScript + Vitest profile

Load this profile together with the parent EXACT Coding Predictive TDD skill when the project uses TypeScript and Vitest.

## Discover project commands first

Read `package.json` before the first cycle and use the project's package manager and declared scripts. Typical gates are:

```bash
pnpm test
pnpm run typecheck
pnpm run lint
```

Not every project declares all three. Use the full test script as the complete-suite command. Where another gate has no script but its tool is installed, invoke it directly; where the tool is absent, skip it rather than inventing an invocation.

Never hide dependency incompatibilities with `--force` or `--legacy-peer-deps`. Check declared peer ranges and select mutually supported versions. Record any deliberate downgrade or pin.

## Test-list convention

Represent future examples with `it.todo()` and activate exactly one per cycle:

```typescript
import { describe, expect, it } from "vitest";
import { behavior } from "./behavior.js";

describe("behavior", () => {
  it("handles the active example", () => {
    expect(behavior(0)).toBe(0);
  });

  it.todo("handles the next example");
});
```

For the up-front Test List phase, create the complete file with inactive entries only:

```typescript
import { describe, it } from "vitest";

describe("Feature Name", () => {
  it.todo("should [behavior] -- [expected value from spec]");
  it.todo("throws RangeError when [invalid condition from spec]");
  it.todo("should [next behavior] -- [expected value from spec]");
});
```

Place the verification tests after all driving tests, inside a nested group named exactly `verification`. The workflow refers to the group by this name; do not translate or extend it:

```typescript
describe("Feature Name", () => {
  it.todo("should [driving behavior] -- [expected value from spec]");
  it.todo("should [next driving behavior] -- [expected value from spec]");

  describe("verification", () => {
    it.todo("should [combination] -- [expected value from spec]");
  });
});
```

Moving a test into the verification group means moving its `it.todo` into that `describe` block before activating it.

Use the import extension and module conventions already established by the project. Use `.spec.ts` unless the project establishes another suffix. `RangeError` is only an example; require an error type only when the specification establishes it or after explicitly stating the chosen observable contract.

## Interpret RED correctly

Inspect Vitest's actual result before comparing it with the prediction:

1. distinguish module resolution and transform failures from assertion failures
2. inspect expected and received values
3. record test-file and test counts
4. distinguish failed, passed, skipped, and todo tests

A missing implementation module may fail before Vitest discovers tests. It is a valid RED only when it is the intended failure for the current baby step. Otherwise revert and choose a smaller or corrected step.

When an activated example is already satisfied by an earlier generalization, follow the already-green exception in the parent skill: predict the passing result, run the suite, record that no production change is needed, and continue without manufacturing a failure.

## TypeScript-oriented GREEN progression

Let the implementation emerge one active example at a time. Typical small steps include:

1. hardcoded return
2. use of an input parameter
3. narrow conditional
4. named domain constants
5. a general expression or recursive relation when forced by another example
6. explicit boundary validation when required by the specification

Do not jump to the final formula merely because TypeScript makes it easy to express.

Treat test-runner transpilation and static type checking as separate signals. Passing tests do not prove that the compiler accepts the project.

Keep domain parameter names during hardcoded GREEN steps. For temporarily unused parameters, prefer a narrow documented lint suppression and remove it when later behavior uses the parameter. Do not add meaningless calculations, branches, calls, or `void` expressions, and do not weaken lint policy globally.

## TypeScript-oriented SRP review

Apply the parent Predictive TDD skill's Single Responsibility Principle at TypeScript boundaries. Keep domain decisions separate from adapters such as JSON parsing and serialization, CLI or HTTP transport, filesystem access, and persistence. Prefer a cohesive function, class, or module whose name states one responsibility; extract a collaborator when separate concerns would change for separate reasons. Keep Vitest setup and fixtures in test code rather than production abstractions, and do not introduce interfaces or classes solely to imitate another language's design style.

## ESLint and smell detection

Configured lint and smell rules are evidence for the Four Rules review. Allow concrete literals in test examples when they express specification inputs and outputs. Prefer named domain constants in production code when literals duplicate knowledge.

Keep test-specific overrides scoped to spec files. Do not weaken production rules globally to accommodate tests. Verify TypeScript, parser, and plugin compatibility before changing dependencies.

## Predictive phase gate

Before every deterministic check, state a falsifiable expectation and run the check immediately. Use the smallest relevant Vitest invocation during diagnosis and the complete suite for cycle closure:

```bash
pnpm test
```

Replace `pnpm` with the project's package manager.

- **RED:** continue only when the active behavior fails for the predicted reason; investigate a mismatch rather than changing production behavior.
- **GREEN:** run the complete suite and configured type check; retain the change only when both pass.
- **REFACTOR:** run the complete suite and applicable type, lint, and smell gates; retain a structural trial only when all pass and intent improves, otherwise narrowly undo that trial.

Do not create method commits or use hard resets as phase transitions. Before completion, run every applicable project-defined gate in its established order. Do not chain uncertain checks while diagnosing a failure if chaining would hide later signals. Record exact Vitest counts and distinguish failed, passed, skipped, and todo tests.
