require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    it { should have_many(:discounts).through(:item) }
  end

  describe "validations" do
    it {should validate_presence_of(:quantity)}
    it {should validate_presence_of(:unit_price)}
    it {should validate_presence_of(:status)}
  end

  describe "class methods" do
    describe "'items_to_ship" do
      it "lists items that need to be shipped" do
        @invoice_item_10 = create(:invoice_item, status: 0)
        @invoice_item_20 = create(:invoice_item, status: 1)
        @invoice_item_30 = create(:invoice_item, status: 2)

        expect(InvoiceItem.items_to_ship.first.invoice_id).to eq(@invoice_item_10.invoice_id)
        expect(InvoiceItem.items_to_ship[1].status).to eq(@invoice_item_20.status)
        expect(InvoiceItem.items_to_ship).not_to include(@invoice_item_30)
      end
    end
  end
end