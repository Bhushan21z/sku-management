class OrdersController < ApplicationController
  def create
    render json: {success: true}
  end

  def lock
    render json: {success: true}
  end
end
