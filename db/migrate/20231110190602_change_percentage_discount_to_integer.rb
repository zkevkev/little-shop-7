class ChangePercentageDiscountToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column(:discounts, :percentage_discount, :integer)
  end
end
