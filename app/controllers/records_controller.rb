class RecordsController < ApplicationController
  before_action :set_record, only: %i[show edit update destroy]

  def index
    @records = current_user.records.order(created_at: :desc)
  end

  def show; end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.result = @record.income ? @record.amount + @record.account.balance : @record.account.balance - @record.amount if @record.account.balance
    if @record.save
      @record.account.balance += @record.income ? @record.amount : -@record.amount
      @record.account.save
      redirect_to(records_path)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit; end

  def update
    @records = current_user.records.where(created_at: (Time.now - 5.minute)..(Time.now)).order(created_at: :desc)
    old_amount = @record.amount
    if @record.update(record_params)
      @records.each do |record|
        record.result += @record.income ? record_params[:amount].to_f - old_amount : -(record_params[:amount].to_f - old_amount)
        record.save
      end
      @record.account.balance += @record.income ? record_params[:amount].to_f - old_amount : -(record_params[:amount].to_f -old_amount)
      @record.account.save
      redirect_to(records_path)
    else
      render(:new, status: :unprocessable_entity)
    end

  end

  def destroy
    @records = current_user.records.where(created_at: (Time.now - 5.minute)..(Time.now)).order(created_at: :desc)
    @records.each do |record|
      record.result -= @record.income ? @record.amount : -@record.amount
      record.save
    end
    @record.account.balance -= @record.income ? @record.amount : -@record.amount
    @record.account.save
    @record.destroy
    redirect_to records_path
  end

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require("record").permit(:amount, :account_id, :category, :note, :plan, :type, :income)
  end
end
