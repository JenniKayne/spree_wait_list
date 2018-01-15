namespace :spree do
  namespace :wait_list do
    desc 'Send back-in-stock emails'
    task notify: :environment do
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
    end
  end
end
