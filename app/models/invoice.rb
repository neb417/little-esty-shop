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
      .order(created_at: :asc)
      .distinct
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discount_revenue(invoice_items)
    invoice_items.total_revenue - discount(invoice_items)
  end

  def discount(invoice_items)
    discount = 0.0
    invoice_items.each do |item|
      unless item.applied_discount.nil?
        discount += item.apply_discount_revenue
      end
    end
    discount
  end
end
