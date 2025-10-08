class Simulation < ApplicationRecord
  # Associations
  belongs_to :investment_type
  has_many :transactions, dependent: :destroy
  has_many :portfolios, dependent: :destroy

  # Enums
  enum :status, { active: 0, completed: 1 }, default: :active

  # Validations
  validates :initial_capital, presence: true, numericality: { greater_than: 0 }
  validates :current_capital, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :months_elapsed, numericality: { greater_than_or_equal_to: 0 }

  # Instance methods
  def profit_loss
    current_capital - initial_capital
  end

  def profit_loss_percentage
    return 0 if initial_capital.zero?
    ((current_capital - initial_capital) / initial_capital * 100).round(2)
  end

  def total_invested
    portfolios.sum { |p| p.quantity * (p.average_price || 0) }
  end

  def buy!(quantity, price_per_unit)
    raise StandardError, "Insufficient funds" unless can_afford?(quantity, price_per_unit)
    engine.execute_buy(quantity, price_per_unit)
    reload
  end

  def sell!(quantity, price_per_unit)
    raise StandardError, "Insufficient quantity" unless has_quantity?(quantity)
    engine.execute_sell(quantity, price_per_unit)
    reload
  end

  def advance!(months)
    engine.advance_time(months)
    reload
  end

  def current_price
    investment_type.base_price
  end

  def can_afford?(quantity, price)
    (quantity * price) <= current_capital
  end

  def has_quantity?(quantity)
    portfolio = portfolios.find_by(investment_type: investment_type)
    return false unless portfolio
    portfolio.quantity >= quantity
  end

  private

  def engine
    @engine ||= SimulationEngine.new(self)
  end
end
