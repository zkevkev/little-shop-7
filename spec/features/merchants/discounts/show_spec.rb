require "rails_helper"

RSpec.describe "merchant discount show page" do
  before :each do
    @merchant_1 = create(:merchant)
    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 20, quantity_threshold: 10)
    @discount_2 = create(:discount, merchant: @merchant_1, percentage_discount: 30, quantity_threshold: 15)
  end

  # Solo #4
  it "shows all information for the discount" do
    visit merchant_discount_path(@merchant_1, @discount_1)
    
    expect(page).to have_content(@merchant_1.name)
    within("#id") do
      expect(page).to have_content("ID: #{@discount_1.id}")
    end
    within("#percentage_discount") do
      expect(page).to have_content("Percentage Discount: 20%")
    end
    within("#quantity_threshold") do
      expect(page).to have_content("Quantity Threshold: #{@discount_1.quantity_threshold}")
    end
  end

  # Solo #4
  it "does not show information from other discounts" do
    visit merchant_discount_path(@merchant_1, @discount_1)

    within("#id") do
      expect(page).to_not have_content(@discount_2.id)
    end
    within("#percentage_discount") do
      expect(page).to_not have_content(@discount_2.percentage_discount)
    end
    within("#quantity_threshold") do
      expect(page).to_not have_content(@discount_2.quantity_threshold)
    end
  end

  # Solo #5
  it "has a link to edit the discount" do
    visit merchant_discount_path(@merchant_1, @discount_1)

    within("#edit-discount") do
      click_link "Edit Discount"
    end

    expect(current_path).to eq(edit_merchant_discount_path(@merchant_1, @discount_1))
  end
end