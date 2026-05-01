Let's create an app for a scraper.

The product supports both **jobs** and **homes**.

## Direction

- Rails 8 monolith
- backend and frontend in Rails
- native tools first
- deploy with Kamal

## Auth

Use the Rails 8 native authentication foundation.

- `User`
- `Session`

`User` should be a real domain entity from the beginning.

## Search domain

Searches are modeled with delegated types:

- `Search`
- `JobSearch`
- `HomeSearch`

### `Search`
- belongs to `User`
- has `name`
- has `active`
- delegates to a typed search record

### `JobSearch`
- query
- location
- remote_mode
- seniority
- salary_min
- salary_max

### `HomeSearch`
- operation_type
- location
- price_min
- price_max
- currency
- rooms
- area_min
- area_max

## Sources

Sources are first-class:

- `Source`
- `SearchSource`

One search can run against multiple compatible sources.

## Execution

Each source-specific search execution is recorded as:

- `SearchRun`

This is the unit that background jobs run.

## Results

Use canonical domain entities plus typed source results:

- `Home`
- `Job`
- `SearchResult`
- `HomeResult`
- `JobResult`

`SearchResult` is deduplicated by:

- `source_id + external_id`

Typed result rules:

- every `HomeResult` belongs to a `Home`
- every `JobResult` belongs to a `Job`

## Result history

Record each result appearance per run with:

- `SearchRunResult`

## Worker direction

A worker will run periodically for active search/source pairs.

The worker should be:

- idempotent
- safe to retry
- observable
