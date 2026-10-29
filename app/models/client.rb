class Client < ApplicationRecord
  has_many :provider_clients, dependent: :destroy
  has_many :providers, through: :provider_clients
  has_many :journal_entries, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
