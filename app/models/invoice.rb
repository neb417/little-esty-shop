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

  def discount_revenue(merchant = nil)
    if merchant == nil
      invoice_items.total_revenue - admin_invoice_discount
    else
      merchant.invoice_items.total_revenue - discount(merchant)
    end
  end

  def discount(merchant)
    discount = 0.0
    merchant.invoice_items.each do |item|
      if !item.applied_discount.nil?
        discount += item.apply_discount_revenue
      end
    end
    discount
  end

  def admin_invoice_discount
    discount = 0.0
    invoice_items.each do |item|
      if !item.applied_discount.nil?
        discount += item.apply_discount_revenue
      end
    end
    discount
  end
end
