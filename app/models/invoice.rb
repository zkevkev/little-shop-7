class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer
  has_many :merchants, through: :items # this might be wrong (one to many)
  has_many :discounts, through: :merchants

  validates :status, presence: true

  enum :status, {"in progress": 0, "completed": 1, "cancelled": 2}

  def date_format
    self.created_at.strftime("%A, %B %d, %Y")
  end

  def total_revenue
    self.invoice_items.sum("quantity * unit_price")
  end

  def calculate_discounts
    invoice_items
    .joins(:discounts)
    .where("discounts.quantity_threshold <= invoice_items.quantity")
    .group("invoice_items.id")
    .select("invoice_items.*, MAX(discounts.percentage_discount) AS percentage_discount")
    .sum("invoice_items.quantity * invoice_items.unit_price * (100 - percentage_discount) / 100")
  end

  def discounted_revenue
    total_revenue = self.total_revenue
    discounts = self.calculate_discounts.values
    if !discounts.empty?
      discounted_revenue = discounts.reduce do |total_revenue, discount|
        total_revenue - discount
      end
    else
      total_revenue
    end
  end
end