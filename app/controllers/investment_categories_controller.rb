class InvestmentCategoriesController < ApplicationController
  def index
    @investment_categories = InvestmentCategory.includes(:investment_types).all
  end

  def show
    @investment_category = InvestmentCategory.includes(:investment_types).find(params[:id])
  end
end
