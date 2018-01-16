module Spree
  class StockRequest < ActiveRecord::Base
    belongs_to :variant
    delegate :product, to: :variant

    validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

    default_scope { order('created_at desc') }

    scope :notified, lambda { |is_notified| where(state: is_notified ? 'notified' : 'new') }
    scope :to_notify, -> { where("state = 'to_notify' AND (in_progress = FALSE OR in_progress IS NULL)") }

    state_machine :state, initial: 'new' do
      event :mark_to_notify do
        transition from: 'new', to: 'to_notify'
      end

      event :notify do
        transition from: 'to_notify', to: 'notified'
      end
      after_transition to: 'notified', do: :send_email

      event :renew do
        transition from: 'to_notify', to: 'new'
      end

      before_transition :mark_in_progress
      after_transition :unmark_in_progress
    end

    def mark_in_progress
      return if in_progress
      self.in_progress = true
      save
    end

    def unmark_in_progress
      return unless in_progress
      self.in_progress = false
      save
    end

    private

    def send_email
      UserMailer.back_in_stock(self).deliver_later
      update_column(:sent_at, Time.now)
    end
  end
end
