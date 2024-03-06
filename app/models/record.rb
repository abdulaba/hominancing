class Record < ApplicationRecord
  belongs_to :account
  belongs_to :plan

  validates :amount, presence: true, comparison: { greater_than: 0 }
  validates :category, :note, presence: true
end
