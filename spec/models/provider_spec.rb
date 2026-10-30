# spec/models/provider_spec.rb
require "rails_helper"

RSpec.describe Provider do
  it "normalizes email to lowercase" do
    expect(build(:provider, email: " ADA@Example.com ").email).to eq("ada@example.com")
  end

  it "requires a name" do
    expect(build(:provider, name: "")).not_to be_valid
  end

  describe "email format" do
    it "accepts a well-formed email" do
      expect(build(:provider, email: "ada@example.com")).to be_valid
    end

    it "rejects malformed emails" do
      [ "plainaddress", "ada@", "@example.com", "ada example@example.com" ].each do |bad|
        provider = build(:provider, email: bad)

        expect(provider).not_to be_valid, "expected #{bad.inspect} to be invalid"
        expect(provider.errors[:email]).to include("is invalid")
      end
    end
  end

  it "destroys its provider links but keeps its clients" do
    link = create(:provider_client)

    link.provider.destroy

    expect(ProviderClient.exists?(link.id)).to be(false)
    expect(Client.exists?(link.client_id)).to be(true)
  end

  it "rejects a duplicate email regardless of case" do
    create(:provider, email: "ada@example.com")
    expect(build(:provider, email: "ADA@example.com")).not_to be_valid
  end
end
