Spree::Variant.class_eval do
  has_many :stock_requests

  def waiting_list
    stock_requests.notified(false)
  end

  def notify_waiting_list
    waiting_list.each(&:mark_to_notify!)
  end
end
