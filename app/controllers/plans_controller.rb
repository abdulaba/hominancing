# app/controllers/plans_controller.rb

class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = Plan.all
    @plan = Plan.new
  end

  def show
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user = current_user
    if @plan.save
      redirect_to plan_path(@plan), notice: 'Plan creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    redirect_to plan_path(@plan) if current_user != @plan.user
  end

  def update
    if @plan.update(plan_params)
      redirect_to plans_path, notice: 'Datos actualizados exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    redirect_to plans_path, notice: 'Plan eliminado exitosamente.'
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title, :goal)
  end
end
