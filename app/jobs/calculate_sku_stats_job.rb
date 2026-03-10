class CalculateSkuStatsJob < ApplicationJob
  queue_as :default

  def perform(skus)
    skus.each do |sku|
      items = LineItem.joins(:order).where(sku: sku, original: true)

      all_items = items.group_by do |item|
        item.order.placed_at.strftime("%G-W%V")
      end
      all_items.each do |week, week_items|
        sum = week_items.sum(&:quantity)
        stat = SkuStat.find_or_initialize_by(sku: sku, week: week)
        stat.total_quantity = sum
        stat.save
      end
    end
  end
end
