class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]
  before_action :set_colors
  def index
    @accounts = policy_scope(Account)
    @account = Account.new
    @form_err = false
  end

  def show
    authorize @account
    @form_err = false
    @record = @account.records.new
    @records = @account.records.order(created_at: :desc)
    @dolar_price = CurrentDolarPrice.last.price

    today = DateTime.now

    start_date = DateTime.parse(params[:start_date]) unless params[:start_date].blank?
    start_date = Date.new(today.year, today.mon, 1) if params[:start_date].blank?
    end_date = DateTime.parse(params[:end_date]) + 23.hour unless params[:end_date].blank?
    end_date = start_date + 1.month if params[:end_date].blank?

    @records = @records.where("created_at <= ?", end_date)
    last_previus_month_record = @records.order(created_at: :desc).first
    @records = @records.where("created_at >= ?", start_date)
    @records = @records.where(income: params[:income] == "T") unless params[:income].blank?

    @tendency = @records.group_by { |record| record[:created_at].to_date.to_s }
    @tendency = grahp_data(@tendency) { |value| value.first.result }

    if @account.records.count == 0
      init = @account.balance
    elsif @records.count == 0 && @account.records.count > 0
      init = last_previus_month_record.result
    else
      record = @records.last
      init = record.income ? record.result - record.amount : record.result + record.amount
    end

    @tendency = complete_values(@tendency, start_date.to_date, end_date.to_date, init)

    @expence = @records.where(income: false).group_by { |record| record[:category] }
    @expence = grahp_data(@expence) { |value| value.map(&:amount).sum }
  end

  def new
    @account = Account.new
    authorize @account
  end

  def create
    @account = Account.new(account_params)
    @account.user = current_user
    authorize @account

    if @account.save
      redirect_to account_path(@account), notice: "Cuenta creada!"
    else
      @form_err = true
      @accounts = policy_scope(Account)
      render "accounts/index", status: :unprocessable_entity
    end
  end

  def edit
    authorize @account
  end

  def update
    authorize @account
    if @account.update(account_params)
      redirect_to account_path(@account), notice: "Cambios hechos!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @account
    @account.destroy
    redirect_to accounts_path, notice: "Cuenta Borrada"
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

  def set_account
    @account = Account.find(params[:id])
  end

  def set_colors
    @colors = %w[#670f22 #9a0526 #E20000 #ff4040 #FF7676
                 #082338 #0303B5 #003785 #1465BB #2196F3
                 #005200 #007B00 #258D19 #4EA93B #588100]
  end

  def account_params
    params.require("account").permit(:name, :balance, :color)
  end
end
