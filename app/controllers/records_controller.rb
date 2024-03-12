class RecordsController < ApplicationController
  before_action :set_record, only: %i[edit update destroy]

  def index
    sql_query = "EXTRACT(MONTH FROM records.created_at) = ? AND EXTRACT(YEAR FROM records.created_at) = ?"
    if params[:month].present? && params[:year].present?
      @records = current_user.records.where(sql_query, params[:month], params[:year]).order(created_at: :desc)
      year = (params[:month].to_i - 1).zero? ? params[:year].to_i - 1 : params[:year]
      month = (params[:month].to_i - 1).zero? ? 12 : params[:month].to_i - 1
    else
      @records = policy_scope(Record)
      @records = current_user.records.where(sql_query, DateTime.now.month, DateTime.now.year).order(created_at: :desc)
      unless @records.empty?
        year = (@records.first.created_at.month.to_i - 1).zero? ? @records.first.created_at.year.to_i - 1 : @records.first.created_at.year.to_i
        month = (@records.first.created_at.month.to_i - 1).zero? ? 12 : @records.first.created_at.month.to_i - 1
      end
    end

    @show_more = current_user.records.where(sql_query, month, year).empty?
    @date = @records.first.created_at unless @records.empty?
    @record = Record.new

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "records", locals: { records: @records, show_more: @show_more }, formats: [:html] }
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
