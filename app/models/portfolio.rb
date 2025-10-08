class Portfolio < ApplicationRecord
  # Associations
  belongs_to :simulation
  belongs_to :investment_type

  # Validations
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :average_price, numericality: { greater_than: 0 }, allow_nil: true
  validates :simulation_id, uniqueness: { scope: :investment_type_id }

  # Instance methods
  def total_value(current_price = nil)
    return 0 if quantity.zero? || average_price.nil?
    price = current_price || average_price
    quantity * price
  end

  def profit_loss(current_price)
    return 0 if quantity.zero? || average_price.nil?
    (current_price - average_price) * quantity
  end

  def profit_loss_percentage(current_price)
    return 0 if average_price.nil? || average_price.zero?
    ((current_price - average_price) / average_price * 100).round(2)
  end
end
