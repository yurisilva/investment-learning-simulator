class Transaction < ApplicationRecord
  # Associations
  belongs_to :simulation

  # Enums
  enum :action, { buy: 0, sell: 1 }

  # Validations
  validates :action, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_per_unit, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }

  # Callbacks
  before_validation :calculate_total_amount, if: -> { quantity.present? && price_per_unit.present? }

  private

  def calculate_total_amount
    self.total_amount = quantity * price_per_unit
  end
end
