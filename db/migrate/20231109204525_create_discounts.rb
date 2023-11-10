class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.float :percentage_discount
      t.integer :quantity_threshold
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
