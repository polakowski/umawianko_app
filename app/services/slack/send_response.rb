module Slack
  class SendResponse
    def self.call(webhook)
      raise Umawianko::RuntimeError, 'Slack webhook is required' if webhook.blank?

      message = ActiveSupport::OrderedOptions.new.tap do |msg|
        # ...
      end

      yield(message) if block_given?

      Slack::Notifier.new(webhook).post(message)
    end
  end
end
