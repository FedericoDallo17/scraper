Let's create an app for a scraper

User:
- id
- email / authentication attributes
- favorite searches
- search history
- timestamps

Search
- type (job or home) - could be delegated type
- active (boolean)
- params (jsonb) - unless delegated type, then we could have attributes for some of the recurrent params
- timestamps

A worker will run hourly to run queries for every active search
The worker will:

We should deploy with kamal
