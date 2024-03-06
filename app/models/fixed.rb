class Fixed < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true
  validates :category, presence: true
end
