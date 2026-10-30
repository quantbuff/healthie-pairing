require "rails_helper"

RSpec.describe Client do
  it "normalizes email to lowercase" do
    expect(create(:client, email: " SAM@Example.com ").email).to eq("sam@example.com")
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
