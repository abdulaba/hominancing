class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :set_colors

  def index
    @plan = Plan.new
    @plans = policy_scope(Plan)
  end

  def show
    authorize @plan
    @progress_percentage = calculate_progress_percentage(@plan)
    @balance_records = @plan.records.limit(10).order(created_at: :desc)
    @status = @plan.completed? ? 'Completado' : 'En progreso'    @plan = @plan.reload
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @plan = Plan.new
    authorize @plan
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user = current_user
    authorize @plan

    if @plan.save
      redirect_to plans_path, notice: "¡Plan creado!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @plan
  end

  def update
    authorize @plan
    if @plan.update(plan_params)
      @plan.update_balance
      redirect_to plan_path(@plan), notice: "¡Cambios hechos!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @plan
    @plan.destroy
    redirect_to plans_path
  end

  def completed?
    balance >= goal
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
    params.require(:plan).permit(:goal, :title, :user_id, :color, :date, :status, :balance)
  end

  def calculate_progress_percentage(plan)
    total_income = plan.records.where(income: true).sum(:amount)
    total_expense = plan.records.where(income: false).sum(:amount)

    plan.balance = total_income - total_expense
    plan.status = (plan.balance >= plan.goal)

    return 0 if plan.goal.zero?

    ((plan.balance) / plan.goal) * 100
  end
end
