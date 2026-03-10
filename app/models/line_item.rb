class LineItem < ApplicationRecord
  belongs_to :order

  validates :sku, presence: true
  validates :quantity, presence: true
end
