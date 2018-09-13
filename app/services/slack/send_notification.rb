module Slack
  class SendNotification
    # this sends notification using slack webhook API
    # learn how to build notifications: https://api.slack.com/docs/messages

    def self.call(webhook, color = EventType::DEFAULT_COLOR)
      raise Umawianko::RuntimeError, 'Slack webhook is required' if webhook.blank?

      message = ActiveSupport::OrderedOptions.new.tap do |msg|
        msg.fallback = 'Notification.'
        msg.color = color
        msg.fields = [] # title, value, short
      end

      yield(message) if block_given?

      notifier = Slack::Notifier.new(webhook)
      notifier.post(attachments: [message])
    end
  end
end
