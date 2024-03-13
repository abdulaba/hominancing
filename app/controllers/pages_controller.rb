class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
    @accounts = current_user.accounts

    today = DateTime.now
    start_date = DateTime.parse(params[:start_date]) unless params[:start_date].blank?
    start_date = Date.new(today.year, today.mon, 1) if params[:start_date].blank?
    end_date = DateTime.parse(params[:end_date]) + 23.hour unless params[:end_date].blank?
    end_date = start_date + 1.month if params[:end_date].blank?

    data = create_tendency_chart(@accounts, start_date, end_date)

    @tendency = data[:tendency]
    @colors = data[:colors]
    @expence = data[:expences]

    @fixeds = current_user.fixeds.sort_by { |fix| fix.next_pay }
    @fixeds = @fixeds.reject {|fix| fix.next_pay <= start_date}
    @fixeds = @fixeds.reject {|fix| fix.next_pay >= end_date}

  end

  private

  def create_tendency_chart(accounts, start_date, end_date)
    result = {tendency: [], colors: [], expences: []}

    accounts.each do |account|
      records = account.records.order(created_at: :desc)
      records = records.where("created_at >= ?", start_date)
      records = records.where("created_at <= ?", end_date)
      pies = create_pie_chart(records, start_date, end_date)
      result[:expences] << pies
      group = records.group_by { |record| record[:created_at].to_date.to_s }
      group = grahp_data(group) { |value| value.last.result }
      if records.count == 0
        init = account.balance
      else
        record = records.first
        init = record.income ? record.result - record.amount : record.result + record.amount
      end
      group = complete_values(group, start_date.to_date, end_date.to_date, init)
      result[:tendency] << {name: account.name, data: group}
      result[:colors] << account.color
    end
    result[:expences] = join_expence_pies(result[:expences])
    result
  end

  def create_pie_chart(records, start_date, end_date)
    expence = records.select {|record| !record.income}.group_by { |record| record[:category] }
    expence = grahp_data(expence) { |record| record.map(&:amount).sum }
  end

  def join_expence_pies(data)
    result = {}
    data.each do |pie|
      pie.each do |key, value|
        if result[key]
          result[key] += value
        else
          result[key] = value
        end
      end
    end
    result
  end

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
