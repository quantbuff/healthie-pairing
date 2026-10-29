require "rails_helper"

RSpec.describe "Core queries" do
  let(:ada) { create(:provider) }
  let(:ben) { create(:provider) }
  let(:sam) { create(:client) }
  let(:kim) { create(:client) }

  before do
    create(:provider_client, provider: ada, client: sam, plan: "premium")
    create(:provider_client, provider: ada, client: kim)
    create(:provider_client, provider: ben, client: sam, plan: "basic")
  end

  it "returns all clients for a provider" do
    expect(ada.clients).to contain_exactly(sam, kim)
  end

  it "returns all providers for a client" do
    expect(sam.providers).to contain_exactly(ada, ben)
  end

  it "returns a client's entries sorted by date" do
    newer = create(:journal_entry, client: sam, created_at: 1.day.ago)
    older = create(:journal_entry, client: sam, created_at: 3.days.ago)
    create(:journal_entry, client: kim)

    expect(sam.journal_entries.chronological).to eq([ older, newer ])
  end

  it "returns entries across a provider's clients sorted by date" do
    first  = create(:journal_entry, client: sam, created_at: 3.days.ago)
    second = create(:journal_entry, client: kim, created_at: 2.days.ago)
    third  = create(:journal_entry, client: sam, created_at: 1.day.ago)
    create(:journal_entry, client: create(:client)) # not Ada's client

    expect(ada.journal_entries.chronological).to eq([ first, second, third ])
  end
end
