class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
    @accounts = current_user.accounts
    @tendency = []
    @colors = []
    @start_date = current_user.records.first.created_at.to_date
    @end_date = current_user.records.last.created_at.to_date

    @accounts.each do |account|
      group = account.records.group_by { |record| record[:created_at].to_date.to_s }
      group = grahp_data(group) { |value| value.last.result }
      if account.records.count == 0
        init = account.balance
      else
        record = account.records.first
        init = record.income ? record.result - record.amount : record.result + record.amount
      end
      group = complete_values(group, @start_date, @end_date, init)
      @tendency << {name: account.name, data: group}
      @colors << account.color
    end
  end

  private

  def complete_values(data, start_date, end_date, initial_value)
    value_default = initial_value
    (start_date..end_date).to_a.each do |date|
      value_default = data[date.to_s] if data[date.to_s]
      unless data[date.to_s]
        data[date.to_s] = value_default
      end
    end
    data
  end

  def grahp_data(data)
    hash = {}
    data.each do |key, value|
      hash[key] = yield(value)
    end
    hash
  end
end
