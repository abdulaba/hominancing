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
    ) unless @fixed.pay?
  end

  def new
    @fixed = Fixed.new
  end

  def create
    @fixed = Fixed.new(fixed_params)
    if @fixed.save
      redirect_to fixed_path(@fixed), notice: "Pago programado creado"
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
    if @fixed.records.count > 0
      @fixed.records.each do |record|
        record.fixed = nil
        record.save
      end
    end

    @fixed.destroy
    redirect_to fixeds_path, notice: "Pago Borrado"
  end

  private

  def set_fixed
    @fixed = Fixed.find(params[:id])
  end

  def fixed_params
    params.require("fixed").permit(:periodicity, :amount, :category, :account_id, :title, :income, :start_date, :plan_id)
  end
end
