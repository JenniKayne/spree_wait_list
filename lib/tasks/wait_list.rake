namespace :spree do
  namespace :wait_list do
    desc 'Send back-in-stock emails'
    task notify: :environment do
      Spree::SendWaitlistNotificationsJob.perform_now
    end

    desc 'Schedule: Send back-in-stock emails'
    task schedule_notify: :environment do
      Spree::SendWaitlistNotificationsJob.perform_later
    end
  end
end
