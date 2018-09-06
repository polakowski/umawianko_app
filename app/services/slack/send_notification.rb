module Slack
  class SendNotification
    DEFAULT_COLOR = :blue

    COLORS = {
      red: '#c60000',
      green: '#36a64f',
      blue: '#00a1ff',
      yellow: '#e5ca44',
      gray: '#8e8e8e'
    }.freeze

    def self.call(webhook, color = DEFAULT_COLOR, &block)
      raise(Umawianko::RuntimeError, 'Slack webhook is required') if webhook.blank?
      raise(Umawianko::RuntimeError, "Invalid color #{color}") if COLORS[color].blank?

      message = ActiveSupport::OrderedOptions.new.tap do |msg|
        msg.fallback = 'Notification.'
        msg.color = COLORS[color]
        msg.title = ''
        msg.text = ''
        msg.fields = [] # title, value, short
      end

      yield(message) if block_given?

      notifier = Slack::Notifier.new(webhook)
      notifier.post(attachments: [message])
    end
  end
end
