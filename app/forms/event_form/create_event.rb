module EventForm
  class CreateEvent < EventForm::Base
    param_key 'event'

    attribute :auto_join, Boolean

    validate :datetime_not_past

    private

    def persist
      create_event and auto_assign_creator
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
  end
end
