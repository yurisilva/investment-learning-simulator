class CreatePortfolios < ActiveRecord::Migration[8.0]
  def change
    create_table :portfolios do |t|
      t.references :simulation, null: false, foreign_key: true
      t.references :investment_type, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0
      t.decimal :average_price, precision: 10, scale: 2

      t.timestamps
    end

    add_index :portfolios, [:simulation_id, :investment_type_id], unique: true
  end
end
