require 'rails_helper'

RSpec.describe SimulationsController, type: :controller do
  render_views(false)

  let(:category) { InvestmentCategory.create!(name: "Stocks", slug: "stocks") }
  let(:investment_type) { category.investment_types.create!(name: "Apple Stock", base_price: 150.0) }

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response.status).to eq(200)
    end

    it "assigns a new simulation to @simulation" do
      get :new
      expect(assigns(:simulation)).to be_a_new(Simulation)
    end

    it "assigns all investment types to @investment_types" do
      get :new
      expect(assigns(:investment_types)).to include(investment_type)
    end

    it "pre-selects investment type when parameter is provided" do
      get :new, params: { investment_type_id: investment_type.id }
      expect(assigns(:simulation).investment_type_id).to eq(investment_type.id)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        { simulation: { investment_type_id: investment_type.id, initial_capital: 10000 } }
      end

      it "creates a new simulation" do
        expect {
          post :create, params: valid_params
        }.to change(Simulation, :count).by(1)
      end

      it "sets current_capital equal to initial_capital" do
        post :create, params: valid_params
        expect(Simulation.last.current_capital).to eq(10000)
      end

      it "redirects to the created simulation" do
        post :create, params: valid_params
        expect(response).to redirect_to(Simulation.last)
      end

      it "sets a success notice" do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('Simulation created successfully.')
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { simulation: { investment_type_id: investment_type.id, initial_capital: -100 } }
      end

      it "does not create a new simulation" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Simulation, :count)
      end

      it "renders the new template" do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end

      it "returns unprocessable entity status" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #show" do
    let(:simulation) do
      Simulation.create!(
        investment_type: investment_type,
        initial_capital: 10000,
        current_capital: 10000
      )
    end

    it "returns a successful response" do
      get :show, params: { id: simulation.id }
      expect(response.status).to eq(200)
    end

    it "assigns the requested simulation to @simulation" do
      get :show, params: { id: simulation.id }
      expect(assigns(:simulation)).to eq(simulation)
    end

    it "assigns transactions to @transactions" do
      transaction = simulation.transactions.create!(
        action: :buy,
        quantity: 10,
        price_per_unit: 150,
        total_amount: 1500
      )

      get :show, params: { id: simulation.id }

      expect(assigns(:transactions)).to include(transaction)
    end

    it "assigns portfolios to @portfolios" do
      portfolio = simulation.portfolios.create!(
        investment_type: investment_type,
        quantity: 10,
        average_price: 150
      )

      get :show, params: { id: simulation.id }

      expect(assigns(:portfolios)).to include(portfolio)
    end
  end

  describe "POST #advance" do
    let(:simulation) do
      Simulation.create!(
        investment_type: investment_type,
        initial_capital: 10000,
        current_capital: 10000,
        months_elapsed: 0
      )
    end

    it "increments months_elapsed by 1" do
      expect {
        post :advance, params: { id: simulation.id }
        simulation.reload
      }.to change(simulation, :months_elapsed).by(1)
    end

    it "redirects to the simulation" do
      post :advance, params: { id: simulation.id }
      expect(response).to redirect_to(simulation)
    end

    it "sets a success notice" do
      post :advance, params: { id: simulation.id }
      expect(flash[:notice]).to eq('Time advanced by 1 month. Price updated!')
    end
  end
end
