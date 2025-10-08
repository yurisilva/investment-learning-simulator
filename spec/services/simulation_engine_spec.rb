require 'rails_helper'

RSpec.describe SimulationEngine, type: :service do
  let(:investment_category) { create(:investment_category, name: 'Stocks') }
  let(:investment_type) { create(:investment_type, name: 'Tech Stock', investment_category: investment_category, base_price: 100.0) }
  let(:simulation) { create(:simulation, investment_type: investment_type, initial_capital: 10000.0, current_capital: 10000.0) }
  let(:engine) { described_class.new(simulation) }

  describe '#initialize' do
    it 'sets the simulation' do
      expect(engine.simulation).to eq(simulation)
    end
  end

  describe '#generate_price_change' do
    it 'generates a price change for stocks' do
      stock_type = create(:investment_type, name: 'Stock', base_price: 100.0)
      change = engine.generate_price_change(stock_type)
      expect(change).to be_a(Float)
      expect(change).to be_between(-20.0, 20.0)
    end

    it 'generates a price change for bonds' do
      bond_type = create(:investment_type, name: 'Bond', base_price: 100.0)
      change = engine.generate_price_change(bond_type)
      expect(change).to be_a(Float)
      expect(change).to be_between(-7.0, 7.0)
    end

    it 'generates a price change for crypto' do
      crypto_type = create(:investment_type, name: 'Cryptocurrency', base_price: 100.0)
      change = engine.generate_price_change(crypto_type)
      expect(change).to be_a(Float)
      expect(change).to be_between(-30.0, 30.0)
    end
  end

  describe '#advance_time' do
    it 'updates months_elapsed on the simulation' do
      expect { engine.advance_time(3) }.to change { simulation.reload.months_elapsed }.by(3)
    end

    it 'generates price changes for the investment type' do
      initial_price = investment_type.base_price
      engine.advance_time(6)
      expect(investment_type.reload.base_price).not_to eq(initial_price)
    end

    it 'handles advancing multiple months' do
      expect { engine.advance_time(12) }.to change { simulation.reload.months_elapsed }.by(12)
    end
  end

  describe '#execute_buy' do
    let(:quantity) { 10 }
    let(:current_price) { 100.0 }

    it 'creates a buy transaction' do
      expect { engine.execute_buy(quantity, current_price) }.to change { simulation.transactions.count }.by(1)
    end

    it 'sets transaction attributes correctly' do
      transaction = engine.execute_buy(quantity, current_price)
      expect(transaction.action).to eq('buy')
      expect(transaction.quantity).to eq(quantity)
      expect(transaction.price_per_unit).to eq(current_price)
      expect(transaction.total_amount).to eq(quantity * current_price)
    end

    it 'decreases current capital' do
      expect { engine.execute_buy(quantity, current_price) }.to change { simulation.reload.current_capital }.by(-(quantity * current_price))
    end

    it 'updates portfolio quantity' do
      engine.execute_buy(quantity, current_price)
      portfolio = simulation.portfolios.find_by(investment_type: investment_type)
      expect(portfolio.quantity).to eq(quantity)
    end

    it 'updates portfolio average price' do
      engine.execute_buy(quantity, current_price)
      portfolio = simulation.portfolios.find_by(investment_type: investment_type)
      expect(portfolio.average_price).to eq(current_price)
    end

    it 'calculates weighted average price on subsequent buys' do
      engine.execute_buy(10, 100.0)
      engine.execute_buy(10, 120.0)
      portfolio = simulation.portfolios.find_by(investment_type: investment_type)
      expect(portfolio.average_price).to eq(110.0)
    end
  end

  describe '#execute_sell' do
    let(:quantity) { 5 }
    let(:current_price) { 120.0 }

    before do
      engine.execute_buy(10, 100.0)
    end

    it 'creates a sell transaction' do
      expect { engine.execute_sell(quantity, current_price) }.to change { simulation.transactions.count }.by(1)
    end

    it 'sets transaction attributes correctly' do
      transaction = engine.execute_sell(quantity, current_price)
      expect(transaction.action).to eq('sell')
      expect(transaction.quantity).to eq(quantity)
      expect(transaction.price_per_unit).to eq(current_price)
      expect(transaction.total_amount).to eq(quantity * current_price)
    end

    it 'increases current capital' do
      expect { engine.execute_sell(quantity, current_price) }.to change { simulation.reload.current_capital }.by(quantity * current_price)
    end

    it 'decreases portfolio quantity' do
      expect { engine.execute_sell(quantity, current_price) }.to change { simulation.portfolios.first.reload.quantity }.by(-quantity)
    end

    it 'raises error when selling more than owned' do
      expect { engine.execute_sell(20, current_price) }.to raise_error(StandardError)
    end
  end

  describe '#calculate_portfolio_value' do
    let(:current_price) { 150.0 }

    before do
      engine.execute_buy(10, 100.0)
    end

    it 'calculates total portfolio value at current price' do
      value = engine.calculate_portfolio_value(current_price)
      expect(value).to eq(10 * current_price)
    end

    it 'returns total capital plus portfolio value' do
      total_value = engine.calculate_portfolio_value(current_price)
      expected_value = simulation.reload.current_capital + (10 * current_price)
      expect(simulation.current_capital + total_value).to eq(expected_value)
    end

    it 'returns zero when no portfolio exists' do
      simulation.portfolios.destroy_all
      value = engine.calculate_portfolio_value(current_price)
      expect(value).to eq(0)
    end
  end
end
