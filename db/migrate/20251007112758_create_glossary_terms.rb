class CreateGlossaryTerms < ActiveRecord::Migration[8.0]
  def change
    create_table :glossary_terms do |t|
      t.string :term, null: false
      t.text :definition, null: false
      t.text :related_categories, array: true, default: []

      t.timestamps
    end

    add_index :glossary_terms, :term, unique: true
  end
end
