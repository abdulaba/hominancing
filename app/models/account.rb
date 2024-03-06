class Account < ApplicationRecord
  belongs_to :user

  has_many :records
  has_many :fixeds

  validates :name, presence: true
end
