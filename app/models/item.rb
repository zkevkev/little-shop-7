class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, :description, :unit_price, :status, presence: true

  enum :status, {enabled: 0, disabled: 1}

  def format_price
    format('%.2f', (self.unit_price / 100.0)).prepend("$")
  end

  def created_format
    created_at.strftime("%A, %B %d, %Y")
  end

  def total_revenue
    invoice_items
  end
end