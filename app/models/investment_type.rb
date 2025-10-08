class InvestmentType < ApplicationRecord
  # Associations
  belongs_to :investment_category
  has_many :simulations, dependent: :destroy
  has_many :portfolios, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
