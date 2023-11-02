class Admin::Dashboard < ApplicationRecord
  include ActiveModel::Model

  def self.top_five
    Customer
    .select("customers.id, customers.first_name, customers.last_name, COUNT(invoices.customer_id) AS transaction_count")
    .joins(:invoices)
    .where(invoices: { status: 1 })
    .group("customers.id, customers.first_name, customers.last_name")
    .order("transaction_count DESC")
    .limit(5)
  end
end
