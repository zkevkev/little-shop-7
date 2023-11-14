require "rails_helper"

RSpec.describe "merchant discounts index page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 20, quantity_threshold: 10)
    @discount_2 = create(:discount, merchant: @merchant_1, percentage_discount: 30, quantity_threshold: 15)
    @discount_3 = create(:discount, merchant: @merchant_1, percentage_discount: 40, quantity_threshold: 20)
    @discount_4 = create(:discount, merchant: @merchant_2, percentage_discount: 70, quantity_threshold: 50)
  end

  # Solo #1
  it "shows all this merchant's discounts and their details" do
    visit merchant_discounts_path(@merchant_1)

    within("#discount-#{@discount_1.id}") do
      expect(page).to have_content(@discount_1.percentage_discount)
      expect(page).to have_content(@discount_1.quantity_threshold)
    end

    within("#discount-#{@discount_2.id}") do
      expect(page).to have_content(@discount_2.percentage_discount)
      expect(page).to have_content(@discount_2.quantity_threshold)
    end
  end

  # Solo #1
  it "discount ids link to that discount's show page" do
    visit merchant_discounts_path(@merchant_1)

    click_link "#{@discount_1.id}"

    expect(current_path).to eq(merchant_discount_path(@merchant_1, @discount_1))
  end

  # Solo #2
  it "has a link to create new discount" do
    visit merchant_discounts_path(@merchant_1)

    expect(page).to have_link("Create New Discount")
  end

  # Solo #2
  it "link to create new discount links to new merchant discount page" do
    visit merchant_discounts_path(@merchant_1)

    click_link "Create New Discount"

    expect(current_path).to eq(new_merchant_discount_path(@merchant_1))
  end

  # Solo #3
  it "delete button next to each discount deletes and routes back" do
    visit merchant_discounts_path(@merchant_1)

    within("#delete-#{@discount_1.id}") do
      expect(page).to have_button("Delete")
      click_button "Delete"
    end

    expect(current_path).to eq(merchant_discounts_path(@merchant_1))
    expect(page).to_not have_content(@discount_1.id)
  end
end