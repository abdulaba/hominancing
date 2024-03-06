class Record < ApplicationRecord
  belongs_to :account
  belongs_to :plan

  validates :amount, presence: true
  validates :category, :note, presence: true
end
