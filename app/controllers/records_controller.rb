class RecordsController < ApplicationController
  before_action :set_record, only: %i[show edit update destroy]

  def index
    @records = Record.all.order(created_at: :desc)
  end

  def show; end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.account.balance += @record.amount
    @record.account.save
    @record.result = @record.account.balance
    @record.save ? redirect_to(records_path) : render(:new, status: :unprocessable_entity)
  end

  def edit; end

  def update
    @record.update(record_params)
    redirect_to(records_path)
  end

  def destroy
    @record.account.balance -= @record.amount
    @record.account.save
    @record.destroy
    redirect_to records_path
  end

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require("record").permit(:amount, :account_id, :category, :note, :plan, :type)
  end
end
