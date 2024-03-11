class FixedsController < ApplicationController
  before_action :set_fixed, only: %i[show edit update destroy]

  def index
    @fixeds = current_user.fixeds
  end

  def show
    @nex_pay = DateTime.parse(@fixed.start_date.to_s)
    #.strftime("%u") saber el dia de la semana
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

  def set_fixed
    @fixed = Fixed.find(params[:id])
  end

  def fixed_params
    params.require("fixed").permit(:periodicity, :amount, :category, :account_id, :title, :income, :start_date)
  end
end
