# Scraper

Scraper app for **jobs** and **homes**, built as a **Rails 8 monolith**.

This repository also exists as a **portfolio project**: it should reflect strong engineering judgment, explicit domain modeling, and deliberate implementation choices.

## Project Intent

This project is intentionally built with a more deliberate approach to programming.

The goal is **not** to avoid AI because of lack of skill. The goal is to avoid over-delegating day-to-day engineering decisions, and to use this repository as a place to practice, think, and ship work that reflects senior-level judgment.

## Principles

- prefer Rails vanilla
- prefer clarity over cleverness
- prefer explicit modeling over generic blobs
- prefer maintainability over premature abstraction
- use AI as support, not as autopilot

## Current Direction

- Rails 8
- monolith application
- backend and frontend in Rails
- native tools preferred, including Hotwire when useful
- multiuser design from the start
- Rails-native auth foundation from the start, with product-facing auth flows expanded later

## Current Status

Completed:

- Rails 8 reset
- project rules and roadmap docs
- Rails-native authentication foundation (`User`, `Session`, sessions/password reset flow)
- source catalog foundation (`Source` with slug-based routing)

Current focus:

- `KAN-13` — typed search models

## Domain

The project supports two search domains:

- jobs
- homes

Searches are modeled with:

- `Search`
- `JobSearch`
- `HomeSearch`

using **delegated type**.

Results are also modeled explicitly with:

- `SearchResult`
- `HomeResult`
- `JobResult`

and canonical domain entities:

- `Home`
- `Job`

### Shared search fields

- user
- active
- name / label
- searchable reference
- timestamps

### Sources

- `Source` is a first-class model
- `Source` uses a unique `slug` as its public identifier
- one `Search` can run against multiple sources through `SearchSource`
- source compatibility is enforced by search type

### Initial job search fields

- query
- mode
- seniority
- salary_min
- salary_max

### Initial home search fields

- price_min
- price_max
- rooms
- area_min
- area_max

### Delegated search creation note

- `Search` and its typed record should preserve a shared invariant
- if creation flows become awkward, prefer a transactional constructor/factory over weakening that invariant

### Result model direction

- `SearchResult` is deduplicated by `source_id + external_id`
- `HomeResult` must belong to a `Home`
- `JobResult` must belong to a `Job`
- each run/result appearance is recorded through `SearchRunResult`

## Execution Model

- periodic searches run in background jobs
- queueing uses **Solid Queue**
- workers must be idempotent
- retries must be safe
- scraping must apply rate limiting
- result deduplication uses `source_id + external_id`

Each execution should persist enough information to understand:

- what ran
- against which source
- how long it took
- how many results were found
- whether it failed or retried

## Source Policy

New scraping sources should be evaluated case by case.

At minimum, review:

- terms of service
- practical rate limits
- operational risk
- data usefulness

## Quality Bar

- no merge without tests for functional changes
- prioritize model, scraper, job, and integration tests
- keep changes small and reviewable
- keep docs current when decisions or workflows change

## Roadmap

### Phase 0 — Reset
- reinitialize the app on Rails 8
- prepare base project structure
- establish project docs and rules

### Phase 1 — Core domain
- add Rails-native auth foundation (`User`, `Session`) ✅
- add `Source` catalog foundation ✅
- add `Search`, `JobSearch`, `HomeSearch`
- add `SearchSource`
- add runs / executions
- add canonical `Home` / `Job`
- add typed results and run appearances

### Phase 2 — Job infrastructure
- configure Solid Queue
- add idempotent execution patterns
- add retries and execution logging

### Phase 3 — Home scraper migration
- migrate the existing home scraper approach into the new architecture
- make it run end-to-end inside this project

### Phase 4 — Notifications
- add notifications on new or relevant results
- avoid duplicate notifications

### Phase 5 — Job scraper
- implement the first job scraper on top of the shared infrastructure

### Phase 6 — Auth
- introduce simple Rails-aligned authentication
- enable real multiuser usage

### Phase 7 — Hardening and deploy
- improve observability and performance
- finalize source policies
- deploy with Kamal

## Reference

- Initial planning notes live in `Plan.md`
- Repository rules live in `RULES.md`
- Technical execution plan lives in `ROADMAP.md`
