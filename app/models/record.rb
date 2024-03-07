class Record < ApplicationRecord
  belongs_to :account
  belongs_to :plan, optional: true

  validates :category, :note, :amount, :type, :result, presence: true
end
