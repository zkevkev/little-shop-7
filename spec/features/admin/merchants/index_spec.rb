require 'rails_helper'

RSpec.describe "Admin Merchants Index", type: :feature do
  before :each do
    @merchant1 = create(:merchant, enabled: true)
    @merchant2 = create(:merchant, enabled: true)
    @merchant3 = create(:merchant, enabled: true)
    @merchant4 = create(:merchant)
    @merchant5 = create(:merchant)

    @customer1 = create(:customer)
    @customer2 = create(:customer)
    @customer3 = create(:customer)
    @customer4 = create(:customer)
    @customer5 = create(:customer)

    @invoice1 = create(:invoice, customer: @customer1)
    @invoice2 = create(:invoice, customer: @customer2)
    @invoice3 = create(:invoice, customer: @customer3)
    @invoice4 = create(:invoice, customer: @customer4)
    @invoice5 = create(:invoice, customer: @customer5)

    @item1 = create(:item, merchant: @merchant1)
    @item2 = create(:item, merchant: @merchant2)
    @item3 = create(:item, merchant: @merchant3)
    @item4 = create(:item, merchant: @merchant4)
    @item5 = create(:item, merchant: @merchant5)

    # Create invoice items with unit prices and quantities associated with invoices
    @invoice_item1 = create(:invoice_item, item: @item1, invoice: @invoice1, unit_price: 10, quantity: 5)
    @invoice_item2 = create(:invoice_item, item: @item2, invoice: @invoice2, unit_price: 15, quantity: 3)
    @invoice_item3 = create(:invoice_item, item: @item3, invoice: @invoice3, unit_price: 8, quantity: 5)
    @invoice_item4 = create(:invoice_item, item: @item4, invoice: @invoice4, unit_price: 9, quantity: 4)
    @invoice_item5 = create(:invoice_item, item: @item5, invoice: @invoice5, unit_price: 9, quantity: 2)

    # Create successful transactions for invoices
    @transaction1 = create(:transaction, invoice: @invoice1, result: 0) # Successful
    @transaction2 = create(:transaction, invoice: @invoice2, result: 0) # Successful
    @transaction3 = create(:transaction, invoice: @invoice3, result: 0) # Successful
    @transaction4 = create(:transaction, invoice: @invoice4, result: 0) # Successful
    @transaction5 = create(:transaction, invoice: @invoice5, result: 0) # Successful
  end

  # US 24
  it "displays the name of each merchant" do
    visit admin_merchants_path

    expect(page).to have_content(@merchant1.name)
    expect(page).to have_content(@merchant2.name)
    expect(page).to have_content(@merchant3.name)
  end

  # US 25
  it "clicking the name redirects to merchant admin show page and displays the name" do
    visit admin_merchants_path

    within("#merchant-#{@merchant1.id}") do
      expect(page).to have_link("#{@merchant1.name}")
      click_link("#{@merchant1.name}")
    end
      expect(page).to have_content("#{@merchant1.name}")
  end

  #US 27/28
  it "displays a button to disable or enable a merchant" do 
    visit admin_merchants_path
    within("#merchant-#{@merchant1.id}") do
      expect(page).to have_content("status: enabled")
      expect(page).to have_button("Disable Merchant")
      click_on("Disable Merchant")
      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_button("Enable Merchant")
      click_on("Enable Merchant")
      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_button("Disable Merchant")
    end
    
    visit admin_merchants_path
    within("#enabled-merchants") do
    expect(page).to have_content("status: enabled")
    expect(page).to_not have_button("Enable Merchant")
    expect(page).to_not have_content("status: disabled")
    end

    visit admin_merchants_path
    within("#disabled-merchants") do
      expect(page).to have_content("status: disabled")
      expect(page).to_not have_button("Disable Merchant")
      expect(page).to_not have_content("status: enabled")
    end
  end

 # US 30
  it "displays the top 5 merchants by total revenue and lists total revenue generated" do
    #puts "Merchant 1 ID: #{@merchant1.id}" (not sure why we had a puts in a test)
    visit admin_merchants_path
  
    expect("#{@merchant1.name}: $50").to appear_before("#{@merchant2.name}: $45")
    expect("#{@merchant2.name}: $45").to appear_before("#{@merchant3.name}: $40")
    expect("#{@merchant3.name}: $40").to appear_before("#{@merchant4.name}: $36")
    expect("#{@merchant4.name}: $36").to appear_before("#{@merchant5.name}: $18")
    expect("#{@merchant5.name}: $18").to_not appear_before("#{@merchant1.name}: $50")

    within("#top_5-#{@merchant1.id}") do
      expect(page).to have_content("#{@merchant1.name}: $50")
      expect(page).to have_link("#{@merchant1.name} ##{@merchant1.id}")
      click_link("#{@merchant1.name} ##{@merchant1.id}")
      expect(current_path).to eq(admin_merchant_path(@merchant1.id))
    end
  end

  #US 31
  it "displays the date of the top 5 merchants most profitable days" do 
    visit admin_merchants_path
    within("all_top_5")
      expect(page).to have_content(Date.today.strftime("%m/%d/%y"))
  end
end
