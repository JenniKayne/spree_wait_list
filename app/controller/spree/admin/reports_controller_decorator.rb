Spree::Admin::ReportsController.class_eval do
  add_available_report! :stock_requests

  def stock_requests
    per_page = 100
    @search = Spree::StockRequest.ransack(params[:q])
    @stock_requests = @search.result.page(params[:page]).per(per_page)
  end
end
