module EventTypeForm
  class CreateEventType < ApplicationForm
    param_key 'event_type'

    attribute :name, String
    attribute :slack_webhook, String
    attribute :color, String
    attribute :icon, String

    validates :name, presence: true
    validates :color, hex_color: true

    private

    def persist
      resource.assign_attributes attributes
      resource.save
    end
  end
end
