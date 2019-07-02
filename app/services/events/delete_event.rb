module Events
  class DeleteEvent < ApplicationService
    def initialize(event)
      @event = event
    end

    def call
      event.destroy

      send_notification if event.deleted?
    end

    private

    attr_reader :event

    def send_notification
      return if event.slack_webhook.nil?

      Slack::SendNotification.call(
        event.slack_webhook,
        event.event_type.color_or_default
      ) do |msg|
        msg.fallback = fallback_text
        msg.text = notification_text
        msg.footer = event.creator.name
        msg.footer_icon = event.creator.image
      end
    end

    def fallback_text
      "#{event.name} deleted"
    end

    def notification_text
      "Event *#{event.name}* was deleted."
    end
  end
end
