module Slack
  class SendResponse
    def self.call(webhook, type: 'ephemeral', replace_original: false)
      raise Umawianko::RuntimeError, 'Slack webhook is required' if webhook.blank?

      message = ActiveSupport::OrderedOptions.new.tap do |msg|
        msg.response_type = type
        msg.replace_original = replace_original
      end

      yield(message) if block_given?

      Slack::Notifier.new(webhook).post(message)
    end
  end
end
