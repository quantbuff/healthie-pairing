require "rails_helper"

RSpec.describe JournalEntry do
  it "requires a body" do
    expect(build(:journal_entry, body: "")).not_to be_valid
  end

  it "requires a client" do
    expect(build(:journal_entry, client: nil)).not_to be_valid
  end

  describe ".chronological" do
    it "breaks created_at ties by id" do
      client = create(:client)
      time = 1.day.ago
      first = create(:journal_entry, client: client, created_at: time)
      second = create(:journal_entry, client: client, created_at: time)

      expect(client.journal_entries.chronological).to eq([ first, second ])
    end
  end
end
