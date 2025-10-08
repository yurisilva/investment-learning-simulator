class TransactionsController < ApplicationController
  before_action :set_simulation

  def create
    quantity = params[:quantity].to_i
    price = params[:price_per_unit].to_f
    trade_action = params[:trade_action]

    begin
      if trade_action == "buy"
        @simulation.buy!(quantity, price)
        redirect_to @simulation, notice: "Buy order executed successfully."
      elsif trade_action == "sell"
        @simulation.sell!(quantity, price)
        redirect_to @simulation, notice: "Sell order executed successfully."
      else
        redirect_to @simulation, alert: "Invalid action: #{trade_action}"
      end
    rescue StandardError => e
      redirect_to @simulation, alert: e.message
    end
  end

  private

  def set_simulation
    @simulation = Simulation.find(params[:simulation_id])
  end
end
