class Record < ApplicationRecord
  belongs_to :account
  belongs_to :plan, optional: true

  validates :amount, presence: true
  validates :category, :note, presence: true
end
