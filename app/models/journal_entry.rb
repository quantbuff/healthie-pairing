class JournalEntry < ApplicationRecord
  belongs_to :client

  validates :body, presence: true
end