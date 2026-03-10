class OrderProcessor
  def self.process(params)
    Order.transaction do
      order = Order.find_by(external_id: params[:external_id])

      if order.blank?
        order = Order.create!(external_id: params[:external_id], placed_at: params[:placed_at])
        line_items = params[:line_items]
        line_items.for_each do |item|
          create_line_items(order, item)
        end
      else
        if order.locaked_at.present? || order.create_at > 15.minutes.ago
          raise "LockedForEdit"
        end
        order.line_items.update_all(original: false)
        # line_items = params[:line_items]
        # line_items.for_each do |item|
        #   create_line_items(order, item)
        # end
      end
      # enqueue job for sku stats
      order
    end
  end

  def self.create_line_items(order, line_item_params)
    order.line_items.create!(
      sku: line_item_params[:sku],
      quantity: line_item_params[:quantity],
      original: true
    )
  end
end
