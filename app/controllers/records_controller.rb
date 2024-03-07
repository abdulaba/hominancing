class RecordsController < ApplicationController
  before_action :set_record, only: %i[show edit update destroy]

  def index
    @records = Record.all
  end

  def show; end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.account.balance += @record.amount
    @record.result = @record.account.balance
    @record.save ? redirect_to(record_path(@record)) : render(:new, status: :unprocessable_entity)
  end

  def edit; end

  def update
    @record.update(record_params)
    redirect_to(record_path(@record))
  end

  def destroy
    @record.account.balance -= @record.amount
    @record.destroy
  end

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require("record").permit(:amount, :account_id, :category, :note, :plan)
  end
end
