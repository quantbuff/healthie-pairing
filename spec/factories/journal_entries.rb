FactoryBot.define do
  factory :journal_entry do
    client { nil }
    body { "MyText" }
  end
end
