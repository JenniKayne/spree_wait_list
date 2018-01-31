module Spree
  class SendWaitlistNotificationsJob < ApplicationJob
    queue_as :waitlist

    def perform
      stock_requests = Spree::StockRequest.to_notify.limit(100)

      unless stock_requests.empty?
        puts Time.now

        stock_requests.each(&:mark_in_progress)
        stock_requests.each do |stock_request|
          begin
            if stock_request.variant.can_supply?
              stock_request.notify!
              puts "#{stock_request.id}: #{stock_request.email} notified"
            else
              stock_request.renew!
              puts "#{stock_request.id}: #{stock_request.email} NOT notified, OOS"
            end
          rescue StandardException => e
            stock_request.unmark_in_progress
            puts "#{stock_request.id}: ERROR #{e.message}"
          end
        end
      end
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: 'Send Waitlist Notifications' })
      raise error
    end
  end
end
