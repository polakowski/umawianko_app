module EventForm
  class CreateEvent < EventForm::Base
    include EventsHelper

    param_key 'event'

    attribute :auto_join, Boolean
    attribute :datetime, DateTime
    attribute :event_type_id, Integer

    validates :datetime, presence: true
    validates :datetime, future: true

    private

    def persist
      create_event and auto_assign_creator and send_notification
    end

    def create_event
      resource.assign_attributes attributes_for_create
      resource.creator = form_owner
      resource.save
    end

    def attributes_for_create
      attributes.except(:auto_join)
    end

    def auto_assign_creator
      return true unless auto_join
      Events::JoinEvent.call(resource, form_owner).result
    end

    def send_notification
      return true if resource.event_type.nil? || resource.event_type.slack_webhook.blank?
      send_slack_notification
    end

    def send_slack_notification
      Slack::SendNotification.call(
        resource.event_type.slack_webhook,
        resource.event_type.color_or_default
      ) do |msg|
        assign_notification_data(msg)
        assign_notification_fields(msg)
        assign_notification_footer(msg)
        assign_notification_action(msg)
      end
    end

    def assign_notification_data(msg)
      msg.fallback = 'New event!'
      msg.author_name = 'New event'
      msg.title = name
      msg.title_link = resource.permalink
    end

    def assign_notification_fields(msg)
      msg.fields = [
        { short: true, title: 'When', value: format_event_date_and_time(resource) },
        { short: true, title: 'Where', value: resource.place }
      ]
    end

    def assign_notification_footer(msg)
      msg.footer = resource.creator.name
      msg.footer_icon = resource.creator.image
    end

    def assign_notification_action(msg)
      msg.callback_id = 'join_event'
      msg.actions = [
        slack_action(
          name: 'events.join_solo',
          text: 'Sign me up',
          style: 'primary'
        ),
        slack_action(
          name: 'events.join_with_friends',
          text: 'Sign me up (with friends)',
          style: 'default'
        )
      ]
    end

    def slack_action(name:, text:, style:)
      {
        name: name,
        text: text,
        type: 'button',
        style: style,
        value: resource.id
      }
    end
  end
end
