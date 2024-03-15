class RecordsController < ApplicationController
  before_action :set_record, only: %i[edit update destroy]
  before_action :set_sql_query, only: %i[index create]
  before_action :set_colors, only: %i[create]
  before_action :set_show_more, only: %i[index]

  def index
    @date = @records.first.created_at unless @records.empty?
    @record = Record.new
    @form_err = false
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "records", locals: { records: @records, show_more: @show_more }, formats: [:html] }
    end
    fetch_dolar_price
  end

  def create
    @record = Record.new(record_params)
    authorize @record
    @record.result = 0
    if @record.save
      @form_err = false
      @record.result = @record.income ? @record.amount + @record.account.balance : @record.account.balance - @record.amount if @record.account.balance
      @record.account.balance += @record.income ? @record.amount : -@record.amount
      @record.account.save
      @record.save
      redirect_back fallback_location: root_path, notice: "¡Registro creado!"
    else
      @form_err = true
      last_controller = Rails.application.routes.recognize_path(request.referrer)[:controller]

      if last_controller == "records"
        set_show_more
        @date = @records.first.created_at unless @records.empty?
        render("records/index", status: :unprocessable_entity)
      elsif last_controller == "accounts"
        @account = @record.account
        authorize @account
        set_graphs
        render("accounts/show", status: :unprocessable_entity)
      elsif last_controller == "plans"
        @plan = @record.plan
        authorize @plan
        @balance_records = @plan.records.limit(10).order(created_at: :desc)
        @progress_percentage = calculate_progress_percentage(@plan) || 0
        @plan.reload
        render("plans/show", status: :unprocessable_entity)
      end

    end
  end

  def edit
    authorize @record
  end

  def update
    authorize @record
    @records = current_user.records.where(created_at: (Time.now - 5.minute)..(Time.now)).order(created_at: :desc)
    old_amount = @record.amount
    if @record.update(record_params)
      @records.each do |record|
        record.result += @record.amount - old_amount
        record.save
      end
      if @record.income
        @record.account.balance -= old_amount - @record.amount
      else
        @record.account.balance += old_amount - @record.amount
      end
      @record.account.save
      redirect_to records_path, notice: "¡Cambios hechos!"
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    authorize @record
    @records = current_user.records.where(created_at: (Time.now - 5.minute)..(Time.now)).order(created_at: :desc)
    @records.each do |record|
      record.result -= @record.income ? @record.amount : -@record.amount
      record.save
    end
    @record.account.balance -= @record.income ? @record.amount : -@record.amount
    @record.account.save
    @record.destroy
    redirect_to records_path, notice: "Registro borrado"
  end

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def set_show_more
    if params[:month].present? && params[:year].present?
      @records = current_user.records.where(@sql_query, params[:month], params[:year]).order(created_at: :desc)
      year = (params[:month].to_i - 1).zero? ? params[:year].to_i - 1 : params[:year]
      month = (params[:month].to_i - 1).zero? ? 12 : params[:month].to_i - 1
    else
      @records = policy_scope(Record)
      @records = current_user.records.where(@sql_query, DateTime.now.month, DateTime.now.year).order(created_at: :desc)
      unless @records.empty?
        year = (@records.first.created_at.month.to_i - 1).zero? ? @records.first.created_at.year.to_i - 1 : @records.first.created_at.year.to_i
        month = (@records.first.created_at.month.to_i - 1).zero? ? 12 : @records.first.created_at.month.to_i - 1
      end
    end

    @show_more = current_user.records.where(@sql_query, month, year).empty?
  end

  def grahp_data(data)
    hash = {}
    data.each do |key, value|
      hash[key] = yield(value)
    end
    hash
  end

  def set_colors
    @colors = %w[#670f22 #9a0526 #E20000 #ff4040 #FF7676
      #082338 #0303B5 #003785 #1465BB #2196F3
      #005200 #007B00 #258D19 #4EA93B #588100]
  end

  def set_sql_query
    @sql_query = "EXTRACT(MONTH FROM records.created_at) = ? AND EXTRACT(YEAR FROM records.created_at) = ?"
  end

  def record_params
    params.require("record").permit(:amount, :account_id, :category, :note, :plan_id, :income, :fixed_id)
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

  def set_graphs
    @records = @account.records.order(created_at: :desc)

    today = DateTime.now

    start_date = DateTime.parse(params[:start_date]) unless params[:start_date].blank?
    start_date = Date.new(today.year, today.mon, 1) if params[:start_date].blank?
    end_date = DateTime.parse(params[:end_date]) + 23.hour unless params[:end_date].blank?
    end_date = start_date + 1.month if params[:end_date].blank?

    @records = @records.where("created_at >= ?", start_date)
    @records = @records.where("created_at <= ?", end_date)
    @records = @records.where(income: params[:income] == "T") unless params[:income].blank?

    @tendency = @records.group_by { |record| record[:created_at].to_date.to_s }
    @tendency = grahp_data(@tendency) { |value| value.first.result }

    if @account.records.count == 0
      init = @account.balance
    else
      record = @account.records.first
      init = record.income ? record.result - record.amount : record.result + record.amount
    end

    @tendency = complete_values(@tendency, start_date.to_date, end_date.to_date, init)

    @expence = @records.where(income: false).group_by { |record| record[:category] }
    @expence = grahp_data(@expence) { |value| value.map(&:amount).sum }
  end

  def calculate_progress_percentage(plan)
    total_income = plan.records.where(income: true).sum(:amount)
    total_expense = plan.records.where(income: false).sum(:amount)

    plan.balance = total_income - total_expense
    plan.status = (plan.balance >= plan.goal)
    plan.save

    if plan.goal.zero?
      return 0
    elsif plan.status
      return 100
    else
      return ((plan.balance.to_f / plan.goal) * 100).round(2)
    end
  end

  def fetch_dolar_price
    require "json"
    require "open-uri"

    url = "https://pydolarvenezuela-api.vercel.app/api/v1/dollar/page?page=bcv&monitor=usd"
    res_serialized = URI.open(url).read
    @res = JSON.parse(res_serialized)

    @dolar_price = res.price
  end
end
