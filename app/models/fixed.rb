class Fixed < ApplicationRecord
  belongs_to :account
  belongs_to :plan, optional: true

  has_many :records

  validates :amount, presence: true
  validates :category, presence: true

  def next_pay
    today = DateTime.now
    day = self.start_date.day
    mon = today.mon
    year = today.year
    next_pay = Date.new(year, mon, day)
    case self.periodicity
    when 0
      if (next_pay - today).to_i < 0
        next_pay += 1.month
      end
    when 1
      next_week_day = self.start_date.strftime("%u").to_i
      week_day = today.strftime("%u").to_i
      if (next_week_day - week_day) < 0
        next_pay += 1.week
      end
    end
    return next_pay
  end

  def periodicity_to_s
    case self.periodicity
    when 0
      return "Mensual"
    when 1
      return "Semanal"
    end
  end
end
