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

## Collaboration workflow

1. Start by identifying the next concrete step.
2. Clarify what needs to be done before writing code.
3. Explicitly define what the developer should do and what the AI should do for each step.
4. Keep important design decisions, domain modeling, and critical thinking with the developer.
5. Because this is a portfolio project, keep the work that adds real learning and portfolio value with the developer.
6. Delegate to AI only the more mechanical work that adds little value when done manually.
7. Use AI for mechanical work, test support, documentation updates, branch creation, and senior-level review.
8. After the developer implements a slice, review it critically and discuss tradeoffs before moving on.
9. Once a ticket has been committed and closed, update the project documentation before moving to the next ticket.
10. Those documentation updates should cover the shipped changes, relevant decisions when needed, and the current project status/focus.

## Architectural direction

1. Rails 8 monolith.
2. Backend and frontend in Rails.
3. Prefer native Rails tools, including Hotwire when useful.
4. The search domain is modeled with `Search` plus delegated types such as `JobSearch` and `HomeSearch`.

## Delivery expectations

1. Functional changes should include relevant tests.
2. Keep changes small and coherent.
3. Update docs when decisions or workflows materially change.
4. After a ticket is closed, update docs to reflect completion and point to the next focus.
5. Prefer clarity over cleverness.
