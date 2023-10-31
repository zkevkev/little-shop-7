require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should have_many(:merchant_id)}
  end

  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:unit_price)}
    it {should validate_presence_of(:description)}
  end
end