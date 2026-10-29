# Healthie pairing: Rails data model

Providers (for example dietitians), their clients, and clients' journal entries.

## Run it

Requires Ruby 4.0+, Rails 8.1 and PostgreSQL.

    bundle install
    bin/rails db:create db:migrate db:seed
    bundle exec rspec

Console: `bin/rails console`. The seeds create 2 providers, 4 clients, 5 pairings and 16 journal entries.

## Data model

- `providers` and `clients`: name and email. Emails are trimmed and lowercased, with a unique index.
- `provider_clients`: joins a provider and a client and carries the `plan` ("basic" or "premium"). Unique on `[provider_id, client_id]`.
- `journal_entries`: free-form `body`, belongs to a client. Index on `[client_id, created_at]`.

### Why these choices

- The plan lives on the join model because a client can be premium with one provider and basic with another. That is why it is `has_many :through` and not HABTM.
- Constraints live in the database as well as the models: `null: false`, foreign keys, unique indexes, and a check constraint on `plan`. Model validations give friendly errors, and the database is the guarantee, for example under concurrent requests.
- Journal entries belong to the client only. Providers reach them through their clients. If per-provider visibility mattered, that would be added explicitly.

## The four queries

    provider.clients                           # all clients for a provider
    client.providers                           # all providers for a client
    client.journal_entries.chronological       # a client's entries, sorted by date
    provider.journal_entries.chronological     # entries across a provider's clients, sorted by date

`chronological` orders by `created_at`, then `id`. `provider.journal_entries` is one query joining entries, clients and provider_clients. See `spec/models/queries_spec.rb`.

## Not done / next

- No API or UI: this is models, queries, seeds and specs only.
- Sorting uses `created_at`. A separate `entry_date` column would be better if clients can backdate entries.
- For a very large dataset: keyset pagination on `(created_at, id)` instead of OFFSET, `includes` against N+1, partitioning entries by month, read replicas for reporting.
- Authorization: providers should only see their own clients' entries. Not implemented.
- The plan check constraint duplicates the enum values. A new plan needs a migration and an enum change.