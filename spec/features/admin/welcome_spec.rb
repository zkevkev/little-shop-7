require "rails_helper"

RSpec.describe "admin dashboard index page" do
  before(:each) do
    @merchant = create(:merchant)
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)
    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice, customer: @customer_2)
    @invoice_3 = create(:invoice, customer: @customer_3)
    @invoice_4 = create(:invoice, customer: @customer_4)
    @invoice_5 = create(:invoice, customer: @customer_5)
    @invoice_6 = create(:invoice, customer: @customer_6)
    @item_1 = create(:item, merchant: @merchant)
    @item_2 = create(:item, merchant: @merchant)
    @item_3 = create(:item, merchant: @merchant)
    @item_4 = create(:item, merchant: @merchant)
    @item_5 = create(:item, merchant: @merchant)
    @item_6 = create(:item, merchant: @merchant)
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2)
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_3)
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_4, item: @item_4)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_5, item: @item_5, status: 2)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_6, item: @item_6)
    @transaction_1 = create_list(:transaction, 5, invoice: @invoice_1, result: 0)
    @transaction_2 = create_list(:transaction, 4, invoice: @invoice_2, result: 0)
    @transaction_3 = create_list(:transaction, 3, invoice: @invoice_3, result: 0)
    @transaction_4 = create_list(:transaction, 2, invoice: @invoice_4, result: 0)
    @transaction_5 = create_list(:transaction, 1, invoice: @invoice_5, result: 0)
    @transaction_6 = create(:transaction, invoice: @invoice_6, result: 1)
  end

  #user story 19
  it "Displays a admin dashboard header" do
    # visit("/admin")
    visit admin_path

    expect(page).to have_content("Welcome to the Admin Dashboard")
  end

  #user story 20
  it "has a link to the admin merchant index" do
    # visit("/admin")
    visit admin_path

    # expect(page).to have_link("Admin Merchants", href: "/admin/merchants")
    click_link("Admin Merchants")
    expect(current_path).to eq(admin_merchants_path)
  end

  #user story 20
  it "has a link to the admin admin invoice index" do
    #  visit("/admin")
    visit admin_path
    # expect(page).to have_link("Admin Invoices", href: "/admin/invoices")
    expect(page).to have_link("Admin Invoices")
    click_link("Admin Invoices")
    # expect(current_path).to eq("/admin/invoices")
    expect(current_path).to eq(admin_invoices_path)
  end

  #user story 21
  it "Displays the names of the top 5 customers" do
    # visit("/admin")
    visit admin_path
    expect(page).to have_content("1. #{@customer_1.first_name} #{@customer_1.last_name} - 5 transactions")
    expect(page).to have_content("2. #{@customer_2.first_name} #{@customer_2.last_name} - 4 transactions")
    expect(page).to have_content("3. #{@customer_3.first_name} #{@customer_3.last_name} - 3 transactions")
    expect(page).to have_content("4. #{@customer_4.first_name} #{@customer_4.last_name} - 2 transactions")
    expect(page).to have_content("5. #{@customer_5.first_name} #{@customer_5.last_name} - 1 transactions")
    expect(@customer_1.last_name).to appear_before(@customer_2.last_name)
    expect(page).to_not have_content(@customer_6.first_name)
  end

  #user story 22 & 23
  it "Displays incomplete invoices with oldest first" do
    visit admin_path
    invoice_1 = find_link("#{@invoice_item_1.invoice_id}")
    invoice_2 = find_link("#{@invoice_item_2.invoice_id}")
    expect(invoice_1).to appear_before(invoice_2)

    expect(page).to have_link("#{@invoice_item_1.invoice_id}")
    expect(page).to have_link("#{@invoice_item_2.invoice_id}")
    expect(page).to have_link("#{@invoice_item_3.invoice_id}")
    expect(page).to have_link("#{@invoice_item_4.invoice_id}")
    expect(page).not_to have_link("#{@invoice_item_5.invoice_id}")
    
    expect(page).to have_link("#{@invoice_item_1.invoice_id}")
    click_link("#{@invoice_item_1.invoice_id}")
    expect(current_path).to eq("/admin/invoices/#{@invoice_item_1.invoice_id}")
  end
end
