class FixedsController < ApplicationController
  before_action :set_fixed, only: %i[show edit update destroy]

  def index
    @fixeds = current_user.fixeds.sort_by { |fix| fix.next_pay }
  end

  def show
    @records = @fixed.records

    @record = Record.new(
      fixed: @fixed,
      amount: @fixed.amount,
      account: @fixed.account,
      category: @fixed.category,
      note: @fixed.title,
      plan: @fixed.plan,
      income: @fixed.income
    ) unless pay?(@records)
  end

  def new
    @fixed = Fixed.new
  end

  def create
    @fixed = Fixed.new(fixed_params)
    if @fixed.save
      redirect_to fixed_path(@fixed), notice: "pago programado creado"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @fixed.update(fixed_params)
      redirect_to fixed_path(@fixed), notice: "Cambios hechos"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fixed.destroy
    redirect_to fixeds_path
  end

  private
  def pay?(records)
    if records.count < 1
      return false
    else
      return @fixed.records.last.created_at.to_date == DateTime.now.to_date
    end
  end

  def set_fixed
    @fixed = Fixed.find(params[:id])
  end

  def fixed_params
    params.require("fixed").permit(:periodicity, :amount, :category, :account_id, :title, :income, :start_date, :plan_id)
  end
end
