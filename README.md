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
- authentication can wait until after the first scraping MVP

## Domain

The project supports two search domains:

- jobs
- homes

Searches are modeled with:

- `Search`
- `JobSearch`
- `HomeSearch`

using **delegated type**.

### Shared search fields

- user
- active
- name / label
- source
- timestamps
- operational metadata such as `last_run_at` / `last_success_at`

### Initial job search fields

- query
- location
- remote_mode
- seniority
- salary_min
- salary_max

### Initial home search fields

- operation_type
- location
- price_min
- price_max
- currency
- rooms
- area_min
- area_max

## Execution Model

- periodic searches run in background jobs
- queueing uses **Solid Queue**
- workers must be idempotent
- retries must be safe
- scraping must apply rate limiting
- deduplication uses `source + external_id`

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
- add `User`
- add `Search`, `JobSearch`, `HomeSearch`
- add runs / executions
- add found results and deduplication

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
