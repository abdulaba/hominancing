class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]
  before_action :set_colors
  def index
    @accounts = current_user.accounts
    @account = Account.new
  end

  def show
    @records = @account.records.order(created_at: :desc)

    @records = @records.where("created_at >= ?", params[:start_date]) unless params[:start_date].blank?
    @records = @records.where("created_at <= ?", DateTime.parse(params[:end_date])+23.hour) unless params[:end_date].blank?
    @records = @records.where(income: params[:income] == "T") unless params[:income].blank?

    @data = {}

    start_date = DateTime.parse(@records.last.created_at.to_date.to_s) unless @records.last.nil?
    end_date = DateTime.parse(@records.first.created_at.to_date.to_s) + 23.hour unless @records.last.nil?
    start_date = DateTime.parse(params[:start_date]) unless params[:start_date].blank?
    end_date = DateTime.parse(params[:end_date]) + 23.hour unless params[:end_date].blank?
    default_value = 0

    days = (end_date - start_date).to_i + 1

    days.times do
      record = @records.where("created_at >= ? AND created_at <= ?", start_date, start_date+23.hour).first

      result = default_value if record.nil?
      unless record.nil?
        result = record.result
        default_value = result
      end

      @data[start_date.to_date.to_s] = result
      start_date += 24.hour
    end
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.user = current_user

    if @account.save
      redirect_to account_path(@account)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to account_path(@account)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path
  end

  private

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
