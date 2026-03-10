class SkuSummaryController < ApplicationController
  def show
    stats = SkuStats.where(sku: params[:sku])

    render json: {
      success: true,
      sku: params[:sku],
      weeks: stats.map { |s|
        { week: s.week, total_quantity: s.total_quantity }
      }
    }
  end
end
