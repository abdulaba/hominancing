class Plan < ApplicationRecord
  belongs_to :user

  has_many :records

  validates :goal, comparison: { greater_than: 0 }
  validates :title, presence: true

  def progress_percentage
    total_income = self.records.where(income: true).sum(:amount)
    total_expense = self.records.where(income: false).sum(:amount)

    self.balance = total_income - total_expense
    self.status = (self.balance >= self.goal)
    self.save

    if self.goal.zero?
      return 0
    elsif self.status
      return 100
    else
      return ((self.balance.to_f / self.goal) * 100).round(2)
    end
  end
end
