class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: { message: "Please add a Name for the item." }
  validates :description, presence: { message: "Please add a description of the item." }
  validates :unit_price, numericality: { message: "Price is not valid" }

  def top_revenue_date
    invoices
    .joins(:invoice_items, :transactions)
    .select('sum(invoice_items.unit_price * invoice_items.quantity) AS item_revenue, invoices.created_at AS best_day')
    .group('invoices.created_at')
    .where('transactions.result =?', 1)
    .order(item_revenue: :DESC, best_day: :desc)
    .first
    .best_day
  end
end
