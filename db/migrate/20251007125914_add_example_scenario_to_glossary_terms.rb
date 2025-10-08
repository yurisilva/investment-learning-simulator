class AddExampleScenarioToGlossaryTerms < ActiveRecord::Migration[8.0]
  def change
    add_column :glossary_terms, :example_scenario, :text
  end
end
