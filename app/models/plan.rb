class Plan < ApplicationRecord
  belongs_to :user

  has_many :records

  validates :goal, comparison: { greater_than: 0 }
  validates :title, presence: true
end
