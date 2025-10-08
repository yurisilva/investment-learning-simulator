class SimulationsController < ApplicationController
  before_action :set_simulation, only: [ :show, :advance ]

  def new
    @simulation = Simulation.new
    @simulation.investment_type_id = params[:investment_type_id] if params[:investment_type_id]
    @investment_types = InvestmentType.includes(:investment_category).all
  end

  def create
    @simulation = Simulation.new(simulation_params)
    @simulation.current_capital = @simulation.initial_capital

    if @simulation.save
      redirect_to @simulation, notice: "Simulation created successfully."
    else
      @investment_types = InvestmentType.includes(:investment_category).all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @transactions = @simulation.transactions.order(created_at: :desc)
    @portfolios = @simulation.portfolios.includes(:investment_type)
  end

  def advance
    @simulation.advance!(1)
    redirect_to @simulation, notice: "Time advanced by 1 month. Price updated!"
  end

  private

  def set_simulation
    @simulation = Simulation.find(params[:id])
  end

  def simulation_params
    params.require(:simulation).permit(:investment_type_id, :initial_capital)
  end
end
