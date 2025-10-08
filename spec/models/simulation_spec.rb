require 'rails_helper'

RSpec.describe Simulation, type: :model do
  let(:investment_category) { create(:investment_category, name: 'Stocks') }
  let(:investment_type) { create(:investment_type, name: 'Tech Stock', investment_category: investment_category, base_price: 100.0) }
  let(:simulation) { create(:simulation, investment_type: investment_type, initial_capital: 10000.0, current_capital: 10000.0) }

  describe 'associations' do
    it 'belongs to investment_type' do
      expect(simulation.investment_type).to eq(investment_type)
    end

    it 'has many transactions' do
      expect(simulation).to respond_to(:transactions)
    end

    it 'has many portfolios' do
      expect(simulation).to respond_to(:portfolios)
    end
  end

  describe 'validations' do
    it 'validates presence of initial_capital' do
      simulation.initial_capital = nil
      expect(simulation).not_to be_valid
    end

    it 'validates presence of current_capital' do
      simulation.current_capital = nil
      expect(simulation).not_to be_valid
    end

    it 'validates initial_capital is greater than 0' do
      simulation.initial_capital = 0
      expect(simulation).not_to be_valid
    end

    it 'validates current_capital is greater than or equal to 0' do
      simulation.current_capital = -1
      expect(simulation).not_to be_valid
    end

    it 'validates months_elapsed is greater than or equal to 0' do
      simulation.months_elapsed = -1
      expect(simulation).not_to be_valid
    end
  end

  describe '#buy!' do
    let(:quantity) { 10 }
    let(:price_per_unit) { 100.0 }

    it 'creates a buy transaction' do
      expect { simulation.buy!(quantity, price_per_unit) }.to change { simulation.transactions.count }.by(1)
    end

    it 'decreases current capital' do
      expect { simulation.buy!(quantity, price_per_unit) }.to change { simulation.current_capital }.by(-(quantity * price_per_unit))
    end

    it 'updates portfolio quantity' do
      simulation.buy!(quantity, price_per_unit)
      portfolio = simulation.portfolios.find_by(investment_type: investment_type)
      expect(portfolio.quantity).to eq(quantity)
    end

    it 'raises error when insufficient funds' do
      expect { simulation.buy!(200, price_per_unit) }.to raise_error(StandardError)
    end
  end

  describe '#sell!' do
    let(:quantity) { 5 }
    let(:price_per_unit) { 120.0 }

    before do
      simulation.buy!(10, 100.0)
    end

    it 'creates a sell transaction' do
      expect { simulation.sell!(quantity, price_per_unit) }.to change { simulation.transactions.count }.by(1)
    end

    it 'increases current capital' do
      expect { simulation.sell!(quantity, price_per_unit) }.to change { simulation.current_capital }.by(quantity * price_per_unit)
    end

    it 'decreases portfolio quantity' do
      portfolio = simulation.portfolios.find_by(investment_type: investment_type)
      expect { simulation.sell!(quantity, price_per_unit) }.to change { portfolio.reload.quantity }.by(-quantity)
    end

    it 'raises error when insufficient quantity' do
      expect { simulation.sell!(20, price_per_unit) }.to raise_error(StandardError)
    end
  end

  describe '#advance!' do
    it 'increases months_elapsed' do
      expect { simulation.advance!(3) }.to change { simulation.months_elapsed }.by(3)
    end

    it 'updates investment type base price' do
      initial_price = investment_type.base_price
      simulation.advance!(6)
      expect(investment_type.reload.base_price).not_to eq(initial_price)
    end
  end

  describe '#current_price' do
    it 'returns the base price of the investment type' do
      expect(simulation.current_price).to eq(investment_type.base_price)
    end

    it 'reflects updated price after advance' do
      simulation.advance!(1)
      expect(simulation.current_price).to eq(investment_type.reload.base_price)
    end
  end

  describe '#can_afford?' do
    it 'returns true when sufficient capital' do
      expect(simulation.can_afford?(10, 100.0)).to be true
    end

    it 'returns false when insufficient capital' do
      expect(simulation.can_afford?(200, 100.0)).to be false
    end

    it 'returns true when exactly enough capital' do
      expect(simulation.can_afford?(100, 100.0)).to be true
    end
  end

  describe '#has_quantity?' do
    before do
      simulation.buy!(10, 100.0)
    end

    it 'returns true when sufficient quantity' do
      expect(simulation.has_quantity?(5)).to be true
    end

    it 'returns false when insufficient quantity' do
      expect(simulation.has_quantity?(20)).to be false
    end

    it 'returns true when exactly enough quantity' do
      expect(simulation.has_quantity?(10)).to be true
    end

    it 'returns false when no portfolio exists' do
      simulation.portfolios.destroy_all
      expect(simulation.has_quantity?(1)).to be false
    end
  end

  describe '#profit_loss' do
    it 'calculates profit correctly' do
      simulation.update!(current_capital: 12000.0)
      expect(simulation.profit_loss).to eq(2000.0)
    end

    it 'calculates loss correctly' do
      simulation.update!(current_capital: 8000.0)
      expect(simulation.profit_loss).to eq(-2000.0)
    end
  end

  describe '#profit_loss_percentage' do
    it 'calculates profit percentage correctly' do
      simulation.update!(current_capital: 12000.0)
      expect(simulation.profit_loss_percentage).to eq(20.0)
    end

    it 'calculates loss percentage correctly' do
      simulation.update!(current_capital: 8000.0)
      expect(simulation.profit_loss_percentage).to eq(-20.0)
    end
  end
end
