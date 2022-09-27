class Invoice < ApplicationRecord

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:in_progress, :completed, :cancelled]

  def merchant_items(merchant)
    invoice_items
      .joins(:item)
      .select('invoice_items.*, items.name, items.merchant_id')
      .where('items.merchant_id = ?', merchant.id)
  end

  def self.incomplete_invoices
    joins(:invoice_items)
      .select('invoices.*')
      .where('invoice_items.status < ?', 2)
      .order(:created_at)
      .distinct
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def apply_bulk_discount
    invoice_items
      .joins(merchant: :bulk_discounts)
      .where('invoice_items.quantity >= bulk_discounts.threshold')
      .select('invoice_items.id, max(invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.percentage / 100.0)) as discount_applied')
      .group('invoice_items.id')
      .sum(& :discount_applied)
  end
end
