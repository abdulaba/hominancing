class RecordsController < ApplicationController
  def index
    @records = Record.all
  end

  def show
  end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.save ? redirect_to(record_path(@record)) : render(:new, status: :unprocessable_entity)
  end

  def edit
  end

  private

  def record_params
    params.require("record").permit(:amount, :account, :category, :note, :plan)
  end
end
