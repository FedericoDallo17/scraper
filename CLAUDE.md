# CLAUDE.md

This repository should be worked on in alignment with the project documents in the root of the repo.

## Read first

Before making significant changes, review:

1. `RULES.md`
2. `README.md`
3. `ROADMAP.md`
4. `Plan.md`

## Working expectations

1. Follow `RULES.md` as the main repository policy document.
2. Treat this project as a **portfolio-quality Rails application**.
3. Optimize for:
   - senior-level judgment
   - maintainability
   - explicit domain modeling
   - Rails-native solutions
4. Avoid premature abstraction.
5. Use AI as support, not autopilot.
6. Do not introduce code that cannot be clearly explained.

## Architectural direction

1. Rails 8 monolith.
2. Backend and frontend in Rails.
3. Prefer native Rails tools, including Hotwire when useful.
4. The search domain is modeled with `Search` plus delegated types such as `JobSearch` and `HomeSearch`.

## Delivery expectations

1. Functional changes should include relevant tests.
2. Keep changes small and coherent.
3. Update docs when decisions or workflows materially change.
4. Prefer clarity over cleverness.
