require "rails_helper"

RSpec.describe Discount, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
  end

  describe "validations" do
    it {should validate_presence_of(:percentage_discount)}
    it {should validate_presence_of(:quantity_threshold)}
  end

  before :each do
    @merchant_1 = create(:merchant)
    @discount_1 = create(:discount, merchant: @merchant_1, percentage_discount: 0.2, quantity_threshold: 10)
  end

  describe "instance methods" do
  end
end