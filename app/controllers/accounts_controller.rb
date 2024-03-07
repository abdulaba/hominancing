class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]
  def index
    @accounts = current_user.accounts
    @account = Account.new
  end

  def show; end

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

  def account_params
    params.require("account").permit(:name, :balance, :color)
  end
end
