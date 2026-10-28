---
name: test-list
description: TDD Test List Phase - Create a comprehensive test list covering every example and rule from the specification
---

# TDD Test List Phase

You are now in the **Test List Phase** of TDD. Follow these instructions to create a comprehensive test list.

## Your Mission

Create a test list using the project's inactive-test mechanism that covers **every rule and every example** from the specification:
1. Read the specification (`prompt.md`) thoroughly -- every rule, every example, every clarifying question (?)
2. Turn each example into at least one inactive test case
3. Order tests from simplest to most complex
4. Separate the **driving tests**, which build the implementation step by step, from the **verification tests**, which confirm what the driving tests already built
5. Keep every test inactive -- NO executable tests yet

## Process

### Step 1: Understand the Feature
Read the complete specification. Pay special attention to integration examples and clarifying
questions (marked with ?) -- these disambiguate rules that may seem open to interpretation in isolation.
- What are all the operations the system must support?
- What rules govern each operation?
- Which examples in the spec illustrate these rules?
- For rejection or failure cases, what is the observable error contract: a thrown error, an error result, a status, or another outcome? If an error is thrown, does the specification define its type and/or message?

### Step 2: Identify Test Cases from the Spec
Walk through the specification section by section. For each rule and each example:
- Create a test case that verifies the described behavior
- Include the **expected values from the spec** in the test description
- If a clarifying question (?) resolves an ambiguity, create a test for the clarified interpretation
- If the spec uses an example-mapping format (rules, examples, questions), every listed example must have a corresponding test
- Make every rejection or failure case explicit in observable terms, such as a thrown error of the profile's representative type, an error result, or an error status
- Include an exact error type or message only when the specification establishes it
- If the specification merely says `rejects`, `fails`, `invalid`, or equivalent without defining the observable contract, choose the most defensible reading of the specification, state that reading explicitly in the test description, and continue; do not silently invent an unstated contract

### Step 3: Order Tests (Simple -> Complex)
Arrange tests in increasing complexity:
1. Simplest case (often empty/zero/single item)
2. Individual rules in isolation
3. Rules with modifiers
4. Combinations of multiple rules
5. Multi-step scenarios (e.g., operations that reference earlier results)

### Step 4: Write Test File
Create the test file using the project's inactive-test syntax. Keep every listed test inactive. Place the driving tests first, in the order from Step 3, and the verification tests after them in a separate group named `verification`, using the grouping construct from the active stack profile. Step 6 decides which tests belong in which group.

### Step 5: Cross-Check Independent Specification Dimensions

Before declaring the list complete, review the specification and the inactive tests as a coverage map:

- Identify independently specified dimensions such as operation, entity or variant, input category, policy attribute, state transition, and observable result.
- For each explicit value named by the specification, ask whether every independently changeable rule that applies to it has a discriminating test. A test of one attribute does not establish another attribute of the same value.
- Look especially for parallel catalogues, mappings, tables, or branches. Ask whether one side could omit an entry while every current test still passes.
- Use a representative test where several values are governed by one uniform rule, but test each value separately when the specification assigns it independent data or when entries can drift independently.
- Check each operation separately. Coverage through quote, parsing, or presentation does not establish policy creation, claim behavior, persistence, or another operation over the same entity.
- For every uncovered cell, add an inactive test or record why an existing test discriminates that cell. Do not create a mechanical Cartesian product when dimensions cannot fail independently.

Use a falsifying counterfactual as the final check: if one explicitly specified entry or rule were removed or changed while neighboring behavior stayed correct, would an inactive test detect it once activated? If not, the list is not complete.

### Step 6: Separate Driving Tests from Verification Tests

The list now serves two purposes, and they need different treatment during implementation.

**Why:** In TDD, a test earns its place in the cycle by failing first. That failure is the evidence that the test can detect the missing behavior and that the next production change is actually needed. A test you already expect to pass once its parts exist gives no direction — it cannot fail for the right reason — but it still protects the implementation against a later change that breaks a combination or drops an entry. Both kinds are valuable. Mixing them makes the driving sequence harder to follow and turns every expected pass into an apparent gap in the Red-Green rhythm.

For each test, ask: once the tests before it are implemented minimally, will this test fail?

- **Driving test:** it requires behavior that no earlier test forces. It stays in the driving sequence, in the place Step 3 gave it.
- **Verification test:** it is expected to pass automatically once the behaviors it combines exist. Typical examples are cross-dimension combinations from Step 5, further values of a rule an earlier test already generalized, and cells that confirm two independently built features compose. Move it into the `verification` group.

Decide each combination on its own merits. A combination whose outcome needs behavior beyond its parts — an interaction rule, a precedence, a special case the specification names for that combination — is a driving test. Place it directly after the driving tests for its parts, not in the verification group.

You will not foresee every generalization now. That is expected: the Predictive TDD cycle re-examines each driving test before activating it and may still move it into the verification group.

### Step 7: Provide Summary

After creating and cross-checking the test list, provide this summary:

```
Test List Created:
**Feature**: [feature name]
**Test File**: [test file path]
**Tests**: [count]

**Driving Tests** (ordered simple -> complex):
1. [first test description]
2. [second test description]
3. [third test description]
...

**Verification Tests**:
- [test description] -- [which driving tests are expected to make it pass]
...

**Coverage Cross-Check**:
- [independent dimensions reviewed]
- [parallel catalogues or operations checked for omissions]
- [why representative tests are discriminating where exhaustive combinations are unnecessary]
```

### Step 8: Verify the Inactive List and Apply the HITL Checkpoint

Predict and run the full suite. Continue only when the inactive list leaves the
suite green; correct the list without implementing behavior if it does not.
Then consult `.claude/skills/exact-coding-shared/human-in-the-loop.md`. Apply the Test-List checkpoint for the active
Autonomy Level and wait for explicit approval when required; otherwise continue
to the first Predictive TDD cycle.

## Important Guidelines

### DO
- Cover **every spec example** with at least one test
- Cover **every operation** described in the spec
- Give **every clarifying question (?)** a corresponding test
- Order tests **simple -> complex**
- Use the project's inactive-test mechanism for all tests
- Include **expected values** in descriptions
- State rejection and failure outcomes as explicit observable contracts
- Name your chosen reading explicitly when the spec leaves a failure mechanism open
- Keep tests **independent**
- One behavior per test
- Make the independent-dimensions cross-check visible in the summary
- Put a test in the `verification` group only when you expect it to pass once the driving tests it relies on are implemented
- Name, for each verification test, the driving tests it relies on

### DON'T
- Write executable tests yet
- Think about implementation instead of behavior
- Turn vague words such as `rejects` into an invented error contract without saying so
- Leave a rejection test vague when its observable outcome is known
- Miss an entire operation described in the spec
- Order randomly
- Park a combination in the `verification` group when its outcome needs behavior its parts do not provide
- Drop a verification test because it is expected to pass -- it is the safety net, not filler
