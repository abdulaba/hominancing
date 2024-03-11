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
    @records = @records.where("created_at <= ?", DateTime.parse(params[:end_date]) + 23.hour) unless params[:end_date].blank?
    @records = @records.where(income: params[:income] == "T") unless params[:income].blank?

    @tendency = @records.group_by { |record| record[:created_at].to_date.to_s }
    @tendency = grahp_data(@tendency) { |value| value.first.result }

    @expence = @records.where(income: false).group_by { |record| record[:category] }
    @expence = grahp_data(@expence) { |value| value.map(&:amount).sum }
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.user = current_user

    if @account.save
      redirect_to account_path(@account), notice: "Cuenta creada!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to account_path(@account), notice: "Cambios hechos!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path
  end

  private

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
