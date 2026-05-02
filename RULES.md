# Repository Rules

## Purpose

This repository exists to build a scraper application for **jobs** and **homes** while also serving as a **portfolio project**.

The goal is not to avoid AI because of lack of skill. The goal is to use this project to practice deliberate engineering, show senior-level judgment, and avoid the habit of delegating too much day-to-day thinking to AI.

## Core Principles

1. **Learning and craftsmanship over speed.**
   This project should reflect strong engineering judgment, not just fast output.

2. **Use AI deliberately, not passively.**
   AI is allowed, but it must support thinking, not replace it.

3. **Prefer Rails vanilla.**
   Default to Rails conventions and native tools before adding custom layers.

4. **Optimize for maintainability.**
   Favor clarity, explicit modeling, and easy refactoring.

5. **Avoid premature abstraction.**
   Add complexity only when it solves a real problem.

## AI Usage Policy

1. AI may be used for:
   - reviewing approaches
   - discussing tradeoffs
   - improving documentation
   - helping with tests
   - unblocking specific problems

2. AI should not be the default way to implement core logic end-to-end.

3. No code should be merged unless it is fully understood and explainable.

4. If a solution can reasonably be implemented manually, manual implementation is preferred.

5. This repository should demonstrate engineering maturity, not dependence on generated code.

## Architecture Rules

1. The project targets **Rails 8**.
2. The app is a **Rails monolith**.
3. Backend and frontend live in the same codebase.
4. Native Rails tools are preferred, including **Hotwire** when useful.
5. Do not optimize for API-only architecture unless a real need appears.

## Domain Modeling Rules

1. The domain includes both **job searches** and **home searches**.
2. Search modeling uses:
   - `Search`
   - `JobSearch`
   - `HomeSearch`
3. `Search` uses **delegated type**.
4. Common behavior and metadata belong in `Search`.
5. Domain-specific filters belong in `JobSearch` and `HomeSearch`.
6. Do not hide the core domain inside a generic `jsonb` blob.

### Common Search Fields

- `user`
- `active`
- `name` / `label`
- delegated searchable reference
- timestamps
- optional operational fields such as `last_run_at` and `last_success_at`

### Source Modeling

- `Source` is a first-class entity
- a `Search` should resolve all active compatible sources by default
- source compatibility should be enforced by search type
- per-search source configuration should not be introduced until there is a real product need for it

### Initial JobSearch Fields

- `query`
- `mode`
- `seniority`
- `salary_min`
- `salary_max`

### Initial HomeSearch Fields

- `price_min`
- `price_max`
- `rooms`
- `area_min`
- `area_max`

## Scrapers and Workers

1. All jobs must be **idempotent**.
2. All retries must be safe.
3. All sources must use **rate limiting**.
4. Every execution must log enough context to debug failures.
5. Source review is handled **case by case**.
6. Terms, limits, and risk must be considered before integrating a source.

### Minimum Execution Data

Each run should record at least:

- `search_id`
- source context
- status
- duration
- result count
- relevant errors
- relevant retries

### Persistence Rules

The system should persist:

- searches
- runs / executions
- found results
- relevant error context

### Deduplication

Base deduplication uses:

- `source_id + external_id`

## Queueing and Background Processing

1. Use **Solid Queue**.
2. Prefer Rails-native background processing patterns.
3. Background execution should be observable and easy to reason about.

## Testing Rules

1. Do not merge functional changes without tests.
2. Critical logic must be covered.
3. Use TDD when it helps design and confidence.
4. Favor tests for:
   - models
   - scrapers
   - jobs
   - integration flows
5. System tests are not a priority at the start unless they clearly add value.

## Workflow Rules

1. Prefer short-lived branches.
2. Prefer small commits.
3. Prefer small PRs.
4. Keep one coherent feature or change per PR.
5. Use the following collaboration workflow with AI support:
   - define the next step before implementing
   - clarify what needs to be done
   - explicitly define what the developer should do and what the AI should do for each step
   - keep important decisions and critical thinking with the developer
   - the developer should own design decisions, domain modeling, and critical thinking
   - because this is a portfolio project, the developer should prioritize work that adds real learning and portfolio value
   - delegate to AI only the mechanical work that adds little value when done manually
   - delegate mechanical work, test support, documentation, and review support to AI when useful
   - the AI should own mechanical work, branch creation, test support, documentation support, and senior-level review
   - let AI create the working branch when requested
   - once a ticket is committed and considered closed, update the documentation before moving on
   - that documentation update should include completed changes, relevant decisions when they matter, and the current project status
   - project status updates should keep ticket state current and make the next active focus explicit
   - after implementation, use AI for senior-level review and tradeoff discussion
6. Before merge, ensure:
   - tests are green
   - lint is clean
   - minimum docs are updated

Even if the project is currently solo-developed, changes should be made as if future collaborators will read and extend them.

## Auth and Multiuser Direction

1. Design the system as **multiuser** from the start.
2. `User` is part of the domain from day one.
3. Authentication should not block the first MVP.
4. When auth is introduced, prefer a simple Rails-aligned solution.

## Documentation Rules

1. `README.md` is the main entry point.
2. Important decisions should be captured in lightweight ADRs.
3. Documentation should explain **why**, not restate obvious code.
4. New scraping sources should have traceable rationale when needed.
5. When a ticket is closed, documentation should be updated to reflect shipped changes, important decisions, and the new current status/focus.

## Definition of Done

A task is done when:

1. it works
2. relevant tests pass
3. lint passes
4. minimum documentation is updated
5. no unjustified complexity was introduced
