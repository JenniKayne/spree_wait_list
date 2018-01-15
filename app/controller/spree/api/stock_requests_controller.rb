module Spree
  module Api
    class StockRequestsController < Spree::Api::BaseController
      def create
        @stock_request = Spree::StockRequest.new(stock_request_params)
        if @stock_request.save
          render json: { success: true, message: Spree.t(:successful_stock_request) }
        else
          render json: { success: false, message: @stock_request.errors }
        end
      end

      private

      def stock_request_params
        params.require(:stock_request).permit(permitted_attributes.stock_request_attributes)
      end
    end
  end
end
