class FixedsController < ApplicationController
  before_action :set_fixed, only: %i[show edit update destroy]

  def index
    @fixed = Fixed.new
    @fixeds = current_user.fixeds.sort_by { |fix| fix.next_pay }
    @form_err = false
  end

  def show
    authorize @fixed
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
    authorize @fixed
  end

  def create
    @fixed = Fixed.new(fixed_params)
    authorize @fixed
    if @fixed.save
      redirect_to fixed_path(@fixed), notice: "Pago programado creado"
    else
      @fixeds = current_user.fixeds.sort_by { |fix| fix.next_pay }
      render "fixeds/index", status: :unprocessable_entity
    end
  end

  def edit
    authorize @fixed
  end

  def update
    authorize @fixed
    if @fixed.update(fixed_params)
      redirect_to fixed_path(@fixed), notice: "Cambios hechos"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @fixed
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
