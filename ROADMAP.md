# Technical Roadmap

This file turns the high-level project direction into an actionable execution plan.

The focus is to reset the project onto a clean **Rails 8 monolith**, establish the shared scraping infrastructure, migrate the existing home scraper into that shape, and then use that experience to build the jobs side.

## Guiding constraints

- portfolio-quality code over rushed output
- Rails-native solutions first
- explicit domain modeling
- minimal premature abstraction
- AI as support, not autopilot

---

## Phase 0 — Reset to Rails 8

### Goal
Replace the current scaffold with a clean Rails 8 base aligned with the chosen architecture.

### Tasks
1. Reinitialize the app as a Rails 8 project with PostgreSQL.
2. Keep the project as a full Rails app, not API-only.
3. Keep the repository-level docs:
   - `Plan.md`
   - `RULES.md`
   - `ROADMAP.md`
4. Recreate baseline project configuration.
5. Verify the app boots, connects to the database, and passes the default test suite.

### Acceptance criteria
- app runs locally
- database is configured
- default tests pass
- documentation remains in place and up to date

### Suggested command sequence
1. preserve docs that must survive the reset
2. regenerate the app with Rails 8 and PostgreSQL
3. restore docs into the new scaffold
4. run setup, test, and lint

---

## Phase 1 — Establish the domain skeleton

### Goal
Create a domain model that is explicit, multiuser-ready, and able to support both search types cleanly.

### Core entities
- `User`
- `Search`
- `JobSearch`
- `HomeSearch`
- `SearchRun` or equivalent execution model
- `SearchResult` or equivalent found-item model

### Tasks
1. Add `User` as a real domain entity.
2. Add `Search` with shared metadata and lifecycle state.
3. Model `JobSearch` and `HomeSearch` using `delegated_type`.
4. Add run tracking for each execution.
5. Add result persistence with deduplication by `source + external_id`.
6. Add DB constraints and indexes for critical integrity rules.

### Shared `Search` fields
- user reference
- active flag
- name / label
- source
- last run metadata if justified early

### Initial `JobSearch` fields
- query
- location
- remote_mode
- seniority
- salary_min
- salary_max

### Initial `HomeSearch` fields
- operation_type
- location
- price_min
- price_max
- currency
- rooms
- area_min
- area_max

### Acceptance criteria
- delegated type is working cleanly
- searches can be created for both domains
- runs and results can be associated correctly
- uniqueness and indexes reflect the real access patterns

---

## Phase 2 — Background execution infrastructure

### Goal
Create a background processing base that is safe, observable, and easy to extend.

### Tasks
1. Configure **Solid Queue**.
2. Define conventions for scraper jobs.
3. Ensure jobs are idempotent.
4. Add safe retry behavior.
5. Record execution state transitions:
   - started
   - succeeded
   - failed
6. Add logging with enough context to debug real failures.

### Required execution metadata
- search id
- source
- status
- duration
- result count
- retry count when applicable
- error details when applicable

### Acceptance criteria
- a search can enqueue and execute in the background
- repeated execution does not corrupt state
- failures are diagnosable from persisted data and logs

---

## Phase 3 — Migrate the existing home scraper

### Goal
Use the existing working home scraper as the first real vertical inside the new system.

### Tasks
1. Review the current home scraper implementation.
2. Split reusable concerns from project-specific shortcuts.
3. Port the scraping and parsing logic into the new app.
4. Adapt it to:
   - `HomeSearch`
   - background jobs
   - run tracking
   - result persistence
   - deduplication
5. Validate the flow end-to-end.

### Deliverable
One production-like search flow for homes that runs through the full new architecture.

### Acceptance criteria
- a `HomeSearch` can be created and executed
- results are stored correctly
- duplicate results are not reinserted
- runs capture useful execution state

---

## Phase 4 — Notifications

### Goal
Close the loop from scraping to user-facing value.

### Tasks
1. Decide notification trigger rules.
2. Avoid duplicate notifications.
3. Associate notifications with new or relevant results.
4. Keep notification logic separate from scraper-specific code.

### Acceptance criteria
- users are notified only for relevant results
- duplicate notifications are prevented
- notification behavior can be tested independently

---

## Phase 5 — Add the first job scraper

### Goal
Validate that the shared architecture works for a second domain.

### Tasks
1. Implement the first jobs source.
2. Map source data into `JobSearch` and results.
3. Reuse the same run/result infrastructure.
4. Refine the common abstractions only if real duplication appears.

### Acceptance criteria
- jobs and homes both run on the same architectural base
- no domain is forced into awkward generic structures
- any abstraction added is justified by real usage across both domains

---

## Phase 6 — Authentication and multiuser support

### Goal
Turn the system into a real multiuser product without letting auth dominate the early build.

### Tasks
1. Add simple Rails-aligned authentication.
2. Scope searches, runs, and notifications to users.
3. Add minimum authorization boundaries.
4. Validate the user flows needed for the MVP.

### Acceptance criteria
- users can sign in and manage their own searches
- user boundaries are enforced
- auth complexity stays proportional to the project stage

---

## Phase 7 — Hardening and deployment

### Goal
Prepare the app for real usage and deployment.

### Tasks
1. Review indexing and query behavior.
2. Improve observability where the first real bottlenecks appear.
3. Document source review decisions with lightweight ADRs.
4. Prepare deployment with **Kamal**.
5. Validate operational basics for recurring background work.

### Acceptance criteria
- deployment is reproducible
- background execution is operationally understandable
- the project is presentable as a portfolio piece

---

## Immediate next actions

If starting implementation now, the recommended order is:

1. reset to Rails 8
2. restore docs and project conventions
3. configure PostgreSQL and verify boot/test
4. model `Search` with delegated type
5. add runs and results
6. configure Solid Queue
7. migrate the existing home scraper
8. add notifications
9. implement the first jobs source
10. add auth

---

## Near-term milestone plan

### Milestone 1
Rails 8 app reset complete and documented.

### Milestone 2
Core domain modeled with delegated type, runs, and results.

### Milestone 3
Home scraper running end-to-end in the new architecture.

### Milestone 4
Notifications working.

### Milestone 5
First jobs scraper live.

### Milestone 6
Authentication and multiuser flows added.

### Milestone 7
Deployment-ready system with Kamal.
