class Record < ApplicationRecord
  belongs_to :account
  belongs_to :plan, optional: true

  validates :category, :note, :amount, :result, presence: true
  validate :account_balance_cannot_be_zero

  def account_balance_cannot_be_zero
    if !income && (account.balance - amount).negative?
      errors.add(:amount, "Este monto dejaría la cuenta con un monto menor quer 0. Monto actual: #{account.balance}")
    end
  end
end
