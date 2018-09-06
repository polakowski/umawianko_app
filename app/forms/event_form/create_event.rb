module EventForm
  class CreateEvent < EventForm::Base
    include EventsHelper

    param_key 'event'

    attribute :auto_join, Boolean
    attribute :datetime, DateTime
    attribute :event_type_id, Integer

    validates :datetime, :event_type_id, presence: true
    validate :datetime_not_past

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

    def datetime_not_past
      return if datetime.blank?
      errors.add(:datetime, I18n.t('errors.event.datetime_in_past')) if datetime.past?
    end

    def send_notification
      Slack::SendNotification.call(resource.event_type.slack_webhook) do |msg|
        msg.fallback = 'New event!'
        msg.title = name
        msg.text = "[Click here to view new event](#{resource.permalink})"
        msg.footer = resource.creator.name
        msg.footer_icon = resource.creator.image
        msg.fields = [
          { short: true, title: 'When', value: format_event_date_and_time(resource) },
          { short: true, title: 'Where', value: resource.place }
        ]
      end
    end
  end
end
