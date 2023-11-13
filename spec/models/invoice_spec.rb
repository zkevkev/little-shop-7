require "rails_helper"

RSpec.describe Invoice, type: :model do
  before :each do
    @date = DateTime.new(2012, 3, 10)
    @merchant_1 = create(:merchant)
    @invoice_1 = create(:invoice, created_at: @date)
    @item_1 = create(:item, merchant: @merchant_1)
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 50_000, quantity: 10)
    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 50, quantity_threshold: 10)
  end

  describe "relationships" do
    it { should have_many(:invoice_items) }
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:discounts).through(:merchants) }
  end

  describe 'validations' do
    it {should validate_presence_of :status}
  end

  describe "instance methods" do
    describe "#date_format" do
      it "can return the created_at date formatted as 'day_of_week, full_month padded_day, year'" do
        expect(@invoice_1.date_format).to eq("Saturday, March 10, 2012")
      end
    end

    describe "#total_revenue" do
      it "can find the total revenue on an invoice" do
        expect(@invoice_1.total_revenue).to eq(500_000)
      end
    end

    describe "#calculate_discounts" do
      it "returns a hash of invoice_item ids linked to discount to be applied" do
        expect(@invoice_1.calculate_discounts).to eq({@invoice_item_1.id => 250_000})
      end
    end

    describe "#discounted_revenue" do
      it "calculates the revenue minus discounts" do
        expect(@invoice_1.discounted_revenue).to eq(250_000)
      end
    end
  end
end