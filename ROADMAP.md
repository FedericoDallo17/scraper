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

## Phase 1 — Establish the domain skeleton

### Goal
Create a domain model that is explicit, multiuser-ready, and able to support both search types cleanly.

### Core entities
- `User`
- `Session`
- `Search`
- `JobSearch`
- `HomeSearch`
- `Source`
- `SearchRun`
- `Home`
- `Job`
- `SearchResult`
- `HomeResult`
- `JobResult`
- `SearchRunResult`

### Tasks
1. Install Rails 8 authentication with the native generator so `User` and `Session` follow Rails conventions from the start. ✅
2. Model `JobSearch` and `HomeSearch` explicitly. ✅
3. Add `Search` with shared metadata and `delegated_type :searchable`. ✅
4. Add `Source` as a first-class entity for scraper sources. ✅
5. Add source compatibility resolution on `Search` so one search runs against all active compatible sources by default. ✅
6. Add `SearchRun` to track executions per search-source pair.
7. Add canonical domain entities `Home` and `Job`.
8. Add `SearchResult` with `delegated_type :resultable` to `HomeResult` and `JobResult`.
9. Add `SearchRunResult` to record each result appearance in each run.
10. Add DB constraints and indexes for critical integrity rules.

### Auth foundation
- use the Rails 8 authentication generator
- keep `User` auth-ready from day one
- accept Rails-native fields such as `email_address` and `password_digest`

### Shared `Search` fields
- user reference
- active flag
- name / label
- delegated searchable reference

Implementation note:
- `Search` and its delegated record should be created as one invariant
- if manual creation becomes cumbersome, add a transactional constructor/factory that persists both sides together

### Source model
- `slug`
- `name`
- `kind` (`job` or `home`)
- `base_url`
- `active`

Current source rules:
- `slug` is the public identifier used in routes
- `slug` is unique
- `name` is unique
- `base_url` is unique
- `kind` is indexed

### Search-source resolution
- `Search` should expose a way to resolve compatible sources
- compatible sources are active sources whose `kind` matches the search type
- `JobSearch` resolves active `job` sources
- `HomeSearch` resolves active `home` sources
- do not add per-search source overrides until a real product need appears

Scope note:
- this replaced the earlier `SearchSource` idea
- the earlier scope is considered outdated until a real need for per-search source selection appears

### Initial `JobSearch` fields
- query
- mode
- seniority
- salary_min
- salary_max

### Initial `HomeSearch` fields
- price_min
- price_max
- rooms
- area_min
- area_max

### `SearchRun` fields
- `search_id`
- `source_id`
- `status`
- `started_at`
- `finished_at`
- `results_count`
- `error_class`
- `error_message`

Suggested initial statuses:
- `pending`
- `running`
- `succeeded`
- `failed`

### Canonical domain models

#### `Home`
- `title`
- `location_text`
- `price_amount`
- `currency`
- `rooms`
- `area`
- `canonical_url`

#### `Job`
- `title`
- `company_name`
- `location_text`
- `salary_min`
- `salary_max`
- `canonical_url`

### Result modeling

`SearchResult` is a shared source-level record and uses `delegated_type` toward `HomeResult` and `JobResult`.

#### Shared `SearchResult` fields
- `source_id`
- `external_id`
- `url`
- `first_seen_at`
- `last_seen_at`
- `raw_payload`
- delegated `resultable`

#### Typed result rules
- every `HomeResult` must belong to a `Home`
- every `JobResult` must belong to a `Job`
- base deduplication is `source_id + external_id`

### Result appearances per run

`SearchRunResult` records each result appearance in a specific run.

Fields:
- `search_run_id`
- `search_result_id`
- `seen_at`
- `position`

### Critical indexes and constraints
- unique `users.email_address`
- unique `sources.slug`
- unique `sources.name`
- unique `sources.base_url`
- unique `search_results(source_id, external_id)`
- unique `search_run_results(search_run_id, search_result_id)`
- index `searches.user_id`
- index `searches(searchable_type, searchable_id)`
- index `search_runs.search_id`
- index `search_runs.source_id`
- index `home_results.home_id`
- index `job_results.job_id`

### Acceptance criteria
- Rails authentication base is installed and working ✅
- source catalog foundation is implemented ✅
- delegated type is working cleanly ✅
- searches can be created for both domains ✅
- one search can resolve all active compatible sources by type ✅
- runs, canonical records, and results can be associated correctly
- each run can record result appearances independently
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
1. Build the product-facing auth flows on top of the Rails-native auth foundation already introduced in Phase 1.
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

1. run the Rails 8 authentication generator
2. add `Source`
3. add `JobSearch` and `HomeSearch`
4. add `Search` with delegated type
5. add source compatibility resolution on `Search` ✅
6. add `SearchRun`
7. add `Home` and `Job`
8. add `SearchResult`, `HomeResult`, and `JobResult`
9. add `SearchRunResult`
10. add model tests for associations, validations, compatibility, and deduplication

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
