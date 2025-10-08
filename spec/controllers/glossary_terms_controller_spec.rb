require 'rails_helper'

RSpec.describe GlossaryTermsController, type: :controller do
  render_views(false)

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response.status).to eq(200)
    end

    it "assigns all glossary terms alphabetically to @glossary_terms" do
      term_b = GlossaryTerm.create!(term: "Bear Market", definition: "Declining market")
      term_a = GlossaryTerm.create!(term: "Asset", definition: "Something of value")

      get :index

      expect(assigns(:glossary_terms)).to eq([ term_a, term_b ])
    end

    context "when category parameter is provided" do
      it "filters glossary terms by category" do
        term_with_stocks = GlossaryTerm.create!(
          term: "Dividend",
          definition: "Payment to shareholders",
          related_categories: [ "stocks" ]
        )
        term_with_bonds = GlossaryTerm.create!(
          term: "Coupon",
          definition: "Bond interest",
          related_categories: [ "bonds" ]
        )

        get :index, params: { category: "stocks" }

        expect(assigns(:glossary_terms)).to include(term_with_stocks)
        expect(assigns(:glossary_terms)).not_to include(term_with_bonds)
      end
    end

    context "when no category parameter is provided" do
      it "returns all glossary terms" do
        term1 = GlossaryTerm.create!(
          term: "Dividend",
          definition: "Payment to shareholders",
          related_categories: [ "stocks" ]
        )
        term2 = GlossaryTerm.create!(
          term: "Coupon",
          definition: "Bond interest",
          related_categories: [ "bonds" ]
        )

        get :index

        expect(assigns(:glossary_terms)).to match_array([ term1, term2 ])
      end
    end
  end

  describe "GET #show" do
    let(:glossary_term) do
      GlossaryTerm.create!(
        term: "Short",
        definition: "Selling borrowed assets",
        related_categories: [ "stocks" ]
      )
    end

    it "returns a successful response" do
      get :show, params: { id: glossary_term.id }
      expect(response.status).to eq(200)
    end

    it "assigns the requested glossary term to @glossary_term" do
      get :show, params: { id: glossary_term.id }
      expect(assigns(:glossary_term)).to eq(glossary_term)
    end

    it "raises error when term not found" do
      expect {
        get :show, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
