# spec/models/provider_client_spec.rb
require "rails_helper"

RSpec.describe ProviderClient do
  it "rejects a duplicate provider and client pair" do
    pc = create(:provider_client)
    dup = build(:provider_client, provider: pc.provider, client: pc.client)
    expect(dup).not_to be_valid
  end

  it "rejects an unknown plan" do
    expect(build(:provider_client, plan: "gold")).not_to be_valid
  end

  it "lets one client be premium with one provider and basic with another" do
    client = create(:client)
    a = create(:provider_client, client: client, plan: "premium")
    b = create(:provider_client, client: client, plan: "basic")
    expect([ a.plan, b.plan ]).to eq(%w[premium basic])
  end
end
