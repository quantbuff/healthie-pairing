# CLAUDE.md

Rails 8.1 API app (Ruby 4.0, PostgreSQL): providers, clients, a join model that carries the plan, and journal entries.

## Commands

- Setup: `bundle install && bin/rails db:create db:migrate db:seed`
- Tests: `bundle exec rspec`
- Console: `bin/rails console`
- Gems install into `vendor/bundle`.

## Domain rules

- The plan ("basic" or "premium") belongs to the `ProviderClient` join model, not to the client.
- Journal entries belong to a client only. Providers reach them via `has_many :through`.
- Emails are normalized (trimmed, lowercased) and unique.

## Conventions

- Enforce rules in the database (`null: false`, foreign keys, unique indexes, check constraint) as well as in model validations.
- Never edit a migration that has already run on a shared database. Add a new one.
- Tests use RSpec and FactoryBot. One factory per file in `spec/factories/`, specs in `spec/models/`.
- Sort journal entries with the `chronological` scope (`created_at`, then `id`).
- Seeds must be idempotent (`find_or_create_by!`).
- Don't add features or gems beyond what is asked. Ask before schema changes.
- Never run `git commit` or `git push`. Leave changes uncommitted for the author to review and commit.