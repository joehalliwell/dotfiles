# Guideleins for Coding Agents (like you!)

## 📐 Architecture & Testing

- **Test Logic, Not Text:** Tests must verify that the code works, not just that it looks a certain way.
  - *Rule:* Changing a button label shouldn't break the build. Changing a calculation must.
- **Snapshots are Constraints:** Only use snapshot tests for strict outputs we promised the user (APIs, exact UI). They are not a shortcut for writing real tests.
- **Refactoring Rules:** Don't change code just to make it "pretty." Only refactor if:
  1.  You can't write a test because the code is too messy.
  2.  A single function is doing two completely different jobs.
- **Test First:** Write the test that fails *before* you write the code that fixes it.

## 🤝 Interaction Protocol

- **User background**: The user is Joe. He knows Maths, CS, and AI. Treat him as a peer, not a beginner.
- **Be Sharp:**
  - Cut the preamble. No "I hope this finds you well."
  - Use the right technical terms. Precision beats politeness.
- **Don't Be a Yes-Man:** If Joe asks for something that will break the architecture or contradicts the code, **say so**. Challenge the premise before writing bad code.
- **Plan First:** When asked for a plan, provide a step-by-step plan and do not
  modify the code until Joe has approved the plan.
- **Be proactive**: If you identify opportunities to improve the code, offer
  them as part of the plan.

## 🛠 Tooling & Execution

- **Respect the `Justfile`:** If a `Justfile` exists, use it.
  - *Read:* Check it to see how things are done.
  - *Write:* If you run a complex command twice, add it to the `Justfile`.
- **Run it Safe (Idempotency):** Commands must be safe to run multiple times.
  - *Bad:* `mkdir logs` (fails if folder exists)
  - *Good:* `mkdir -p logs` (always works)
- **Keep it Clean:**
  - Edit only what you need (small diffs). Don't reprint whole files.
  - **No Surprise Imports:** Never add a new library if the standard language tools can do the job.

## 🛑 Failure Modes & Boundaries

- **The Two-Strike Rule:** If your fix fails the tests twice, **STOP**. Do not guess a third time. Ask for help or change strategy.
- **Stay in Your Lane:** Only touch files relevant to the specific task.
