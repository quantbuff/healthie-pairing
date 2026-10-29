FactoryBot.define do
  factory :journal_entry do
    client
    body { "Felt fine today" }
  end
end