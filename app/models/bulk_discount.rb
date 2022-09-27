class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :threshold, numericality: true
  validates_numericality_of :percentage, greater_than_or_equal_to: 1
  validates_numericality_of :percentage, less_than_or_equal_to: 100
end