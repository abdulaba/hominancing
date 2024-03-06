class Fixed < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, comparison: { greater_than: 0 }
  validates :category, presence: true
end
