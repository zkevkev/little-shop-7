require "rails_helper"

RSpec.describe "merchant discounts index page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 0.2, quantity_threshold: 10)
    @discount_2 = create(:discount, merchant: @merchant_1, percentage_discount: 0.3, quantity_threshold: 15)
    @discount_3 = create(:discount, merchant: @merchant_1, percentage_discount: 0.4, quantity_threshold: 20)
    @discount_4 = create(:discount, merchant: @merchant_2, percentage_discount: 0.4, quantity_threshold: 20)
  end

  it "shows all this merchant's discounts and their details" do
    visit merchant_discounts_path(@merchant_1)

    expect(page).to have_content(@discount_1.percentage_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)
    expect(page).to have_content(@discount_2.percentage_discount)
    expect(page).to have_content(@discount_2.quantity_threshold)
  end

  it "does not show discounts from any other merchants" do
    visit merchant_discounts_path(@merchant_1)

    expect(page).to_not have_content(@discount_3.percentage_discount)
    expect(page).to_not have_content(@discount_3.quantity_threshold)
  end
end