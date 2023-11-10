class Discount < ApplicationRecord
  belongs_to :merchant

  validates :percentage_discount, :quantity_threshold, presence: true
end