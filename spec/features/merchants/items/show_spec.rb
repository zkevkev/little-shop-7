require "rails_helper"

RSpec.describe "merchant item show page" do
  before :each do
    @merchant_1 = create(:merchant)
    @item_1 = create(:item, merchant: @merchant_1)
  end

  # US7
  it "shows the name, description, and current selling price of the item" do
    visit merchant_item_path(@merchant_1, @item_1)

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_1.description)
    # Will need to normalize this to dollars
    expect(page).to have_content(@item_1.unit_price)
  end
end