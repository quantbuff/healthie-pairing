require "rails_helper"

RSpec.describe Client do
  it "normalizes email to lowercase" do
    expect(build(:client, email: " SAM@Example.com ").email).to eq("sam@example.com")
  end

  it "requires a name" do
    expect(build(:client, name: "")).not_to be_valid
  end

  describe "email format" do
    it "accepts a well-formed email" do
      expect(build(:client, email: "sam@example.com")).to be_valid
    end

    it "rejects malformed emails" do
      [ "plainaddress", "sam@", "@example.com", "sam example@example.com" ].each do |bad|
        client = build(:client, email: bad)

        expect(client).not_to be_valid, "expected #{bad.inspect} to be invalid"
        expect(client.errors[:email]).to include("is invalid")
      end
    end
  end

  it "destroys its journal entries and provider links with it" do
    entry = create(:journal_entry)
    link = create(:provider_client, client: entry.client)

    entry.client.destroy

    expect(JournalEntry.exists?(entry.id)).to be(false)
    expect(ProviderClient.exists?(link.id)).to be(false)
  end

  it "rejects a duplicate email regardless of case" do
    create(:client, email: "sam@example.com")
    expect(build(:client, email: "SAM@example.com")).not_to be_valid
  end

  it "rejects a duplicate email at the database level" do
    create(:client, email: "sam@example.com")
    expect { build(:client, email: "sam@example.com").save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
