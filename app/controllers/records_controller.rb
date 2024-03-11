class RecordsController < ApplicationController
  before_action :set_record, only: %i[edit update destroy]

  def index
    if params[:query].present?
      @records = current_user.records.where("records.id < ?", params[:query]).limit(10).order(created_at: :desc)
    else
      @records = policy_scope(Record)
      @records = current_user.records.limit(10).order(created_at: :desc)
    end
    @record = Record.new

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "records", locals: { records: @records }, formats: [:html] }
    end
  end

  def create
    @record = Record.new(record_params)
    authorize @record
    @record.result = @record.income ? @record.amount + @record.account.balance : @record.account.balance - @record.amount if @record.account.balance
    if @record.save
      @record.account.balance += @record.income ? @record.amount : -@record.amount
      @record.account.save
      redirect_to records_path, notice: "¡Registro creado!"
    else
      render(:new, status: :unprocessable_entity)
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
        record.result += @record.income ? @record.amount - old_amount : -(@record.amount - old_amount)
        record.save
      end
      @record.account.balance += @record.income ? @record.amount - old_amount : -(@record.amount - old_amount)
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
    redirect_to records_path
  end

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require("record").permit(:amount, :account_id, :category, :note, :plan_id, :type, :income)
  end
end
