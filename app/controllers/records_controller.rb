class RecordsController < ApplicationController
  before_action :set_record, only: %i[show edit update]

  def index
    @records = Record.all
  end

  def show; end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.save ? redirect_to(record_path(@record)) : render(:new, status: :unprocessable_entity)
  end

  def edit; end

  def update
    @record.update(record_params)
    redirect_to(record_path(@record))
  end

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require("record").permit(:amount, :account_id, :category, :note, :plan)
  end
end
