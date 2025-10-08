require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:category) { InvestmentCategory.create!(name: "Stocks", slug: "stocks") }
  let(:investment_type) { category.investment_types.create!(name: "Apple Stock", base_price: 150.0) }
  let(:simulation) do
    Simulation.create!(
      investment_type: investment_type,
      initial_capital: 10000,
      current_capital: 10000
    )
  end

  describe "POST #create" do
    context "with valid buy transaction" do
      let(:valid_buy_params) do
        {
          simulation_id: simulation.id,
          trade_action: 'buy',
          quantity: 10,
          price_per_unit: 150
        }
      end

      it "creates a new transaction" do
        expect {
          post :create, params: valid_buy_params
        }.to change(simulation.transactions, :count).by(1)
      end

      it "decreases simulation current_capital" do
        expect {
          post :create, params: valid_buy_params
          simulation.reload
        }.to change(simulation, :current_capital).by(-1500)
      end

      it "redirects to the simulation" do
        post :create, params: valid_buy_params
        expect(response).to redirect_to(simulation)
      end

      it "sets a success notice" do
        post :create, params: valid_buy_params
        expect(flash[:notice]).to eq('Buy order executed successfully.')
      end
    end

    context "with valid sell transaction" do
      before do
        simulation.buy!(10, 150)
      end

      let(:valid_sell_params) do
        {
          simulation_id: simulation.id,
          trade_action: 'sell',
          quantity: 5,
          price_per_unit: 160
        }
      end

      it "creates a new transaction" do
        expect {
          post :create, params: valid_sell_params
        }.to change(simulation.transactions, :count).by(1)
      end

      it "increases simulation current_capital" do
        expect {
          post :create, params: valid_sell_params
          simulation.reload
        }.to change(simulation, :current_capital).by(800)
      end

      it "redirects to the simulation" do
        post :create, params: valid_sell_params
        expect(response).to redirect_to(simulation)
      end
    end

    context "with invalid transaction parameters" do
      let(:invalid_params) do
        {
          simulation_id: simulation.id,
          trade_action: 'buy',
          quantity: 1000000,
          price_per_unit: 150
        }
      end

      it "does not create a transaction" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Transaction, :count)
      end

      it "redirects to the simulation" do
        post :create, params: invalid_params
        expect(response).to redirect_to(simulation)
      end

      it "sets an alert with error messages" do
        post :create, params: invalid_params
        expect(flash[:alert]).to be_present
      end
    end

    context "when simulation does not exist" do
      it "raises an error" do
        expect {
          post :create, params: {
            simulation_id: 999999,
            trade_action: 'buy',
            quantity: 10,
            price_per_unit: 150
          }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
