class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :set_colors

  def index
    @plan = Plan.new
    @plans = current_user.plans
  end

  def show
    @progress_percentage = calculate_progress_percentage(@plan)
    @records = @plan.records
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user = current_user

    if @plan.save
      redirect_to plans_path, notice: "¡Plan creado!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @plan.update(plan_params)
      redirect_to plan_path(@plan), notice: "¡Cambios hechos!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    redirect_to plans_path
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def set_colors
    @colors = %w[#670f22 #9a0526 #E20000 #ff4040 #FF7676
                 #082338 #0303B5 #003785 #1465BB #2196F3
                 #005200 #007B00 #258D19 #4EA93B #588100]
  end

  def plan_params
    params.require(:plan).permit(:title, :goal, :color, :date)
  end

  def calculate_progress_percentage(plan)
    total_income = plan.records.where(income: true).sum(:amount)
    total_expense = plan.records.where(income: false).sum(:amount)

    return 0 if plan.goal.zero? # Para evitar división por cero

    ((total_income - total_expense) / plan.goal) * 100
  end

end
