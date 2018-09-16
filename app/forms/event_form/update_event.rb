module EventForm
  class UpdateEvent < EventForm::Base
    param_key 'event'

    validate :datetime_in_the_future

    private

    def persist
      update_event
    end

    def update_event
      resource.assign_attributes attributes
      resource.save
    end

    def datetime_in_the_future
      return true if resource.future?
      errors.add(:base, I18n.t('errors.event_type.datetime_past'))
    end
  end
end
