FactoryBot.define do
  factory :provider_client do
    provider
    client
    plan { "basic" }
  end
end
