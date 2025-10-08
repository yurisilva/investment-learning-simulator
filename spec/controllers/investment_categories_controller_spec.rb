require 'rails_helper'

RSpec.describe InvestmentCategoriesController, type: :controller do
  render_views(false)

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response.status).to eq(200)
    end

    it "assigns all investment categories to @investment_categories" do
      category1 = InvestmentCategory.create!(name: "Stocks", slug: "stocks")
      category2 = InvestmentCategory.create!(name: "Bonds", slug: "bonds")

      get :index

      expect(assigns(:investment_categories)).to match_array([category1, category2])
    end

    it "includes investment types association" do
      category = InvestmentCategory.create!(name: "Stocks", slug: "stocks")
      investment_type = category.investment_types.create!(name: "Apple Stock")

      get :index

      expect(assigns(:investment_categories).first.investment_types).to be_loaded
    end
  end

  describe "GET #show" do
    let(:category) { InvestmentCategory.create!(name: "Stocks", slug: "stocks") }

    it "returns a successful response" do
      get :show, params: { id: category.id }
      expect(response.status).to eq(200)
    end

    it "assigns the requested investment category to @investment_category" do
      get :show, params: { id: category.id }
      expect(assigns(:investment_category)).to eq(category)
    end

    it "includes investment types association" do
      investment_type = category.investment_types.create!(name: "Apple Stock")

      get :show, params: { id: category.id }

      expect(assigns(:investment_category).investment_types).to be_loaded
    end

    it "raises an error when category not found" do
      expect {
        get :show, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
