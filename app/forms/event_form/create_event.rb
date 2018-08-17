module EventForm
  class CreateEvent < EventForm::Base
    param_key 'event'

    validate :datetime_not_past

    private

    def persist
      create_event
    end

    def create_event
      resource.assign_attributes attributes
      resource.creator = form_owner
      resource.save!
    end

    def datetime_not_past
      return if datetime.blank?
      errors.add(:datetime, I18n.t('errors.event.datetime_in_past')) if datetime.past?
    end
  end
end
