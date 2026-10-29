ada = Provider.find_or_create_by!(email: "ada@example.com") { |p| p.name = "Dr. Ada Lovelace" }
ben = Provider.find_or_create_by!(email: "ben@example.com") { |p| p.name = "Ben Carter, RD" }

clients = %w[sam kim lee zoe].map do |n|
  Client.find_or_create_by!(email: "#{n}@example.com") { |c| c.name = n.capitalize }
end
sam, kim, lee, zoe = clients

[[ada, sam, "premium"], [ada, kim, "basic"], [ada, lee, "basic"],
 [ben, sam, "basic"], [ben, zoe, "premium"]].each do |provider, client, plan|
  ProviderClient.find_or_create_by!(provider: provider, client: client) { |pc| pc.plan = plan }
end

clients.each_with_index do |client, i|
  next if client.journal_entries.exists?

  4.times do |d|
    client.journal_entries.create!(
      body: "#{client.name}, day #{d + 1}: sample journal entry.",
      created_at: (i * 2 + d * 3 + 1).days.ago
    )
  end
end