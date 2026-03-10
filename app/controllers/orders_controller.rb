class OrdersController < ApplicationController
  def create
    order = Order.process(order_params)
    render json: { success: true, order: order }
  rescue => e
    if e.message == "LockedForEdit"
      render json: { success: false, error: "LockedForEdit" }
    else
      render json: { success: false, error: e.message }
    end
  end

  def lock
    order = Order.find_by(id: params[:id])
    order.update!(locaked_at: Time.current)

    render json: { success: true, message: "Order Locked" }
  end

  private

  def order_params
    params.permit(:external_id, :placed_at, line_items: [:sku, :quantity])
  end
end
