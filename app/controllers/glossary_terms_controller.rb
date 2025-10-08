class GlossaryTermsController < ApplicationController
  def index
    @glossary_terms = if params[:category].present?
      GlossaryTerm.by_category(params[:category]).alphabetical
    else
      GlossaryTerm.alphabetical
    end
  end

  def show
    @glossary_term = GlossaryTerm.find(params[:id])
  end
end
