require "rails_helper"

RSpec.describe "new merchant discount page" do
  before :each do
    @merchant_1 = create(:merchant)
    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 0.2, quantity_threshold: 10)
    @discount_2 = create(:discount, merchant: @merchant_1, percentage_discount: 0.3, quantity_threshold: 15)
  end

  # Solo #2
  it "has a form to create a new discount for this merchant" do
    visit new_merchant_discount_path(@merchant_1)

    expect(page).to have_field(:percentage_discount)
    expect(page).to have_field(:quantity_threshold)
    expect(page).to have_button("Create Discount")
  end

  # Solo #2
  it "when filled out with valid data, it creates a new discount and redirects to index" do
    visit new_merchant_discount_path(@merchant_1)

    fill_in :percentage_discount, with: "50"
    fill_in :quantity_threshold, with: "30"
    click_button "Create Discount"

    expect(current_path).to eq(merchant_discounts_path(@merchant_1))
    expect(page).to have_content("50")
    expect(page).to have_content("30")
  end

  # Solo #2
  it "when filled out with invalid data, redirects back with an error" do
    visit new_merchant_discount_path(@merchant_1)

    fill_in :percentage_discount, with: ""
    fill_in :quantity_threshold, with: "30"
    click_button "Create Discount"

    expect(current_path).to eq(new_merchant_discount_path(@merchant_1))
    expect(page).to have_content("Error: Percentage discount can't be blank")
  end
end