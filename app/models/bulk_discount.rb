class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :threshold, numericality: true
  validates :percentage, numericality: true
  
end