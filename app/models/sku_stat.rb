class SkuStat < ApplicationRecord
  validates :sku, presence: true
  validates :week, presence: true
end
