class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]

  def self.total_revenue
    sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def item_name
    item.name
  end

  def invoice_date
    invoice.created_at
  end

  def applied_discount
    bulk_discounts
      .where('bulk_discounts.threshold <= ?', quantity)
      .order(percentage: :desc)
      .first
  end
end
