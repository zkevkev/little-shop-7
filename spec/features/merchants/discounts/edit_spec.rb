require "rails_helper"

RSpec.describe "merchant discount edit page" do
  before :each do
    @merchant_1 = create(:merchant)
    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 20, quantity_threshold: 10)
  end

  # Solo #5
  it "has a form that is prepopulated with existing discount attributes" do
    visit edit_merchant_discount_path(@merchant_1, @discount_1)

    expect(page).to have_field(:percentage_discount, with: @discount_1.percentage_discount)
    expect(page).to have_field(:quantity_threshold, with: @discount_1.quantity_threshold)
    expect(page).to have_button("Update Discount")
  end

  # Solo #5
  it "with valid data, updates the discount and redirects to merchant discount show page" do
    visit edit_merchant_discount_path(@merchant_1, @discount_1)

    within("#update-discount-form") do
      fill_in :percentage_discount, with: 100
      fill_in :quantity_threshold, with: 1_000
      click_button "Update Discount"
    end

    expect(current_path).to eq(merchant_discount_path(@merchant_1, @discount_1))
    expect(page).to have_content("Percentage Discount: 100%")
    expect(page).to have_content("Quantity Threshold: 1000")
  end

  # Solo #5
  it "with invalid data, fashes an error and redirects back" do
    visit edit_merchant_discount_path(@merchant_1, @discount_1)

    within("#update-discount-form") do
      fill_in :percentage_discount, with: ""
      fill_in :quantity_threshold, with: 1_000
      click_button "Update Discount"
    end

    expect(page).to have_content("Error: Percentage discount can't be blank")
    expect(current_path).to eq(edit_merchant_discount_path(@merchant_1, @discount_1))
  end
end