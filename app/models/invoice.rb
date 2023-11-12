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
    .sum("invoice_items.quantity * invoice_items.unit_price * percentage_discount / 100")
    .values
    .first
  end

  def discounted_revenue
    if self.discounts.present?
      self.total_revenue - self.calculate_discounts
    else
      self.total_revenue
    end
  end
end