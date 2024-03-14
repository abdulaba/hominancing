class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :set_colors

  def index
    @plan = Plan.new
    @plans = policy_scope(Plan)
    @form_err = false
  end

def show
  authorize @plan
  @record = @plan.records.new
  @form_err = false
  @balance_records = @plan.records.limit(10).order(created_at: :desc)
  @plan.reload

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
    @plan.balance = 0
    @plan.status = false
    authorize @plan

    if @plan.save
      redirect_to plans_path, notice: "¡Plan creado!"
    else
      @plans = policy_scope(Plan)
      render "plans/index", status: :unprocessable_entity
    end
  end

  def edit
    authorize @plan
  end

  def update
    authorize @plan
    if @plan.update(plan_params)
      total_income = 0
      @plan.records.select(&:income).each { |record| total_income += record.amount }
      total_expense = 0
      @plan.records.reject(&:income).each { |record| total_expense += record.amount }

      @plan.balance = total_income - total_expense
      @plan.status = (@plan.balance >= @plan.goal)
      @plan.save

      if @plan.balance == @plan.goal
        @plan.update(status: 'culminado')
      end

      redirect_to plan_path(@plan), notice: "¡Cambios hechos!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @plan
    if @plan.records.count > 0
      @plan.records.each do |record|
        record.plan = nil
        record.save
      end
    end
    @plan.destroy
    redirect_to plans_path, notice: "Plan Borrado"
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
end
