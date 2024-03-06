class Record < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true
  validates :category, :note, presence: true
end
