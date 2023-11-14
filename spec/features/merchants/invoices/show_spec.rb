require "rails_helper"

RSpec.describe "merchant invoice show page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)
    @customer_7 = create(:customer)
    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice, customer: @customer_2)
    @invoice_3 = create(:invoice, customer: @customer_3)
    @invoice_4 = create(:invoice, customer: @customer_4)
    @invoice_5 = create(:invoice, customer: @customer_5)
    @invoice_6 = create(:invoice, customer: @customer_6)
    @invoice_7 = create(:invoice, customer: @customer_7)
    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)
    @item_4 = create(:item, merchant: @merchant_1)
    @item_5 = create(:item, merchant: @merchant_1)
    @item_6 = create(:item, merchant: @merchant_1)
    @item_7 = create(:item, merchant: @merchant_2)
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 50_000, quantity: 2)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2)
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_3)
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_4, item: @item_4)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_5, item: @item_5)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_6, item: @item_6, status: 2)
    @invoice_item_7 = create(:invoice_item, invoice: @invoice_7, item: @item_7)
    @transaction_1 = create_list(:transaction, 5, invoice: @invoice_1, result: 0)
    @transaction_2 = create_list(:transaction, 4, invoice: @invoice_2, result: 0)
    @transaction_3 = create_list(:transaction, 3, invoice: @invoice_3, result: 0)
    @transaction_4 = create_list(:transaction, 2, invoice: @invoice_4, result: 0)
    @transaction_5 = create_list(:transaction, 1, invoice: @invoice_5, result: 0)
    @transaction_6 = create(:transaction, invoice: @invoice_6, result: 1)
    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 50, quantity_threshold: 2)
    @discount_2 = create(:discount, merchant: @merchant_1, percentage_discount: 50, quantity_threshold: 20)
  end

  #US 15
  describe "Merchant Invoice Show Page" do
    it "Shows invoice information" do
      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.date_format)
      expect(page).to have_content(@invoice_1.customer.first_name)
      expect(page).to have_content(@invoice_1.customer.last_name)
    end
  end

  #US 16
  describe "Merchant Invoice Show Page: Invoice Item Information" do
    it "shows items on the invoice related to the merchent" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to_not have_content(@item_7.name)
    end

    it "shows total revenue generated for an invoice" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("#total-revenue") do
        expect(page).to have_content("$1,000.00")
      end
    end

    # Solo #6
    it "shows the total revenue minus discounts for this merchant invoice" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("#discounted-total-revenue") do
        expect(page).to have_content("$500.00")
      end
    end

    # Solo #7
    it "has a link next to each item to the discount applied" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("#discount-#{@invoice_item_1.id}") do
        expect(page).to have_link("#{@discount_1.id}")
        expect(page).to_not have_link("#{@discount_2.id}")
      end
    end

    # Solo #7
    it "discount applied link routes to dicount show page" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("#discount-#{@invoice_item_1.id}") do
        click_link "#{@discount_1.id}"
      end

      expect(current_path).to eq(merchant_discount_path(@merchant_1, @discount_1))
    end
  end

  #US 18
  describe "Merchant Invoice Show Page: Update Item Status" do
    it "select field and update button" do
      visit"/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
      
      
      within("#the-status-#{@invoice_item_1.id}") do
        click_button("Update Invoice")
      end

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")
    end
  end
end