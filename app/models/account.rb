class Account < ApplicationRecord
  belongs_to :user

  has_many :records, dependent: :destroy
  has_many :fixeds, dependent: :destroy

  validates :name, presence: true
end
