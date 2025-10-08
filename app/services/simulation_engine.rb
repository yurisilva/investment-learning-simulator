class SimulationEngine
  attr_reader :simulation

  def initialize(simulation)
    @simulation = simulation
  end

  def advance_time(months)
    months.times do
      apply_monthly_price_change
      simulation.increment!(:months_elapsed)
    end
  end

  def generate_price_change(investment_type)
    volatility = calculate_volatility(investment_type)
    trend = calculate_trend
    base_change = rand(-volatility..volatility)
    base_change + trend
  end

  def execute_buy(quantity, current_price)
    total_cost = quantity * current_price
    ActiveRecord::Base.transaction do
      update_portfolio_for_buy(quantity, current_price)
      simulation.update!(current_capital: simulation.current_capital - total_cost)
      create_transaction("buy", quantity, current_price)
    end
  end

  def execute_sell(quantity, current_price)
    portfolio = find_or_create_portfolio
    raise StandardError, "Insufficient quantity to sell" if portfolio.quantity < quantity

    total_revenue = quantity * current_price
    ActiveRecord::Base.transaction do
      portfolio.update!(quantity: portfolio.quantity - quantity)
      simulation.update!(current_capital: simulation.current_capital + total_revenue)
      create_transaction("sell", quantity, current_price)
    end
  end

  def calculate_portfolio_value(current_price)
    portfolio = simulation.portfolios.find_by(investment_type: simulation.investment_type)
    return 0 unless portfolio
    portfolio.quantity * current_price
  end

  private

  def calculate_volatility(investment_type)
    name_lower = investment_type.name.downcase
    return 30.0 if name_lower.include?("crypto")
    return 5.0 if name_lower.include?("bond")
    20.0
  end

  def calculate_trend
    rand(-2.0..2.0)
  end

  def apply_monthly_price_change
    investment_type = simulation.investment_type
    price_change = generate_price_change(investment_type)
    new_price = [ investment_type.base_price + price_change, 1.0 ].max
    investment_type.update!(base_price: new_price)
  end

  def update_portfolio_for_buy(quantity, current_price)
    portfolio = find_or_create_portfolio
    new_quantity = portfolio.quantity + quantity
    new_average_price = calculate_weighted_average(portfolio, quantity, current_price)
    portfolio.update!(quantity: new_quantity, average_price: new_average_price)
  end

  def calculate_weighted_average(portfolio, new_quantity, new_price)
    if portfolio.quantity.zero? || portfolio.average_price.nil?
      new_price
    else
      total_cost = (portfolio.quantity * portfolio.average_price) + (new_quantity * new_price)
      total_quantity = portfolio.quantity + new_quantity
      total_cost / total_quantity
    end
  end

  def find_or_create_portfolio
    simulation.portfolios.find_or_create_by!(investment_type: simulation.investment_type) do |p|
      p.quantity = 0
      p.average_price = nil
    end
  end

  def create_transaction(action, quantity, price_per_unit)
    simulation.transactions.create!(
      action: action,
      quantity: quantity,
      price_per_unit: price_per_unit,
      total_amount: quantity * price_per_unit
    )
  end
end
