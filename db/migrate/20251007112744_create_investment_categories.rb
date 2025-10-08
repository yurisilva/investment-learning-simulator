class CreateInvestmentCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :investment_categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.text :how_it_works
      t.text :affecting_factors

      t.timestamps
    end

    add_index :investment_categories, :slug, unique: true
  end
end
