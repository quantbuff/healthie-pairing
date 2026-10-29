class JournalEntry < ApplicationRecord
  belongs_to :client

  validates :body, presence: true

  scope :chronological, -> { order(:created_at, :id) }
end
