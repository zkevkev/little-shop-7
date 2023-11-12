require "rails_helper"

RSpec.describe "Admin Invoices Index Page" do
  before :each do
    @merchant_1 = create(:merchant)
    @customer = create(:customer)
    @invoice1 = create(:invoice, customer: @customer, status: 0)
    
    # Create first item and associated invoice item
    @item1 = create(:item, merchant: @merchant_1) 
    @invoice_item1 = create(:invoice_item, invoice: @invoice1, item: @item1, unit_price: 50_000, quantity: 10)
    
    # Create second item and associated invoice item
    @item2 = create(:item, merchant: @merchant_1) 
    @invoice_item2 = create(:invoice_item, invoice: @invoice1, item: @item2, unit_price: 50_000, quantity: 20)

    # Create a transaction for the invoice
    create(:transaction, invoice: @invoice1) 

    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 25, quantity_threshold: 2)
    @discount_2 = create(:discount, merchant: @merchant_1, percentage_discount: 50, quantity_threshold: 20)
    @discount_3 = create(:discount, merchant: @merchant_1, percentage_discount: 75, quantity_threshold: 30)
  end

  # US 33
  it "lists all of the invoice details on the show page" do
    visit admin_invoice_path(@invoice1.id)

    expect(page).to have_content("ID: ##{@invoice1.id}")
    expect(page).to have_content("Status: #{@invoice1.status}")
    expect(page).to have_content("Customer: #{@invoice1.customer.full_name}")
    expect(page).to have_content("Created Date: #{@invoice1.date_format}")
  end

  # US 34
  it "displays all invoice items and attributes" do
    visit admin_invoice_path(@invoice1.id)

    @invoice1.invoice_items.each do |invoice_item|
      within("#invoice-item-#{invoice_item.id}") do
        expect(page).to have_content("Item: #{invoice_item.item.name}")
        expect(page).to have_content("Quantity Ordered: #{invoice_item.quantity}")
        expect(page).to have_content("Sold Price: #{invoice_item.unit_price}")
        expect(page).to have_content("Invoice Item Status: #{invoice_item.status}")
      end
    end
  end 

  # US 35
  it "displays the total revenue generated from the invoice" do
    visit admin_invoice_path(@invoice1.id)

    expect(page).to have_content("Total Revenue: $#{@invoice1.total_revenue}")
  end

  it "displays the total revenue minus discounts from the invoice" do
    visit admin_invoice_path(@invoice1.id)

    expect(page).to have_content("Total Discounted Revenue: $8,750.00")
  end

  # US 36
  it "displays a select field for invoice status and updates the field" do
    visit admin_invoice_path(@invoice1.id)

    expect(@invoice1.status).to eq("in progress")

    select "completed", from: "status"
    click_button "Update Invoice Status"

    @invoice1.reload

    expect(@invoice1.status).to eq("completed")
  end
end 