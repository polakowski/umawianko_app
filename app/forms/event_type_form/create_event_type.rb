module EventTypeForm
  class CreateEventType < ApplicationForm
    param_key 'event_type'

    COLOR_REGEX = /\A\#([\da-f]{3}){1,2}\z/i

    attribute :name, String
    attribute :slack_webhook, String
    attribute :color, String

    validates :name, :slack_webhook, presence: true
    validate :color_format

    private

    def persist
      resource.assign_attributes attributes
      resource.save
    end

    def color_format
      return if color.match(COLOR_REGEX)
      errors.add(:color, 'is invalid')
      false
    end
  end
end
