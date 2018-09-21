module EventUserForm
  class CreateEventUser < EventUserForm::Base
    attribute :event_id, Integer
    attribute :friends_count, Integer

    validate :event_datetime_in_future
    validate :friends_count_numericality

    private

    def persist
      join_event
    end

    def join_event
      @resource = Events::JoinEvent.call(event, form_owner, friends_count).result
    end

    def friends_count_numericality
      return true if friends_count.blank? || (0..100).cover?(friends_count)
      errors.add(:friends_count, 'is invalid')
    end

    def event_datetime_in_future
      return true if event.future?
      errors.add(:base, I18n.t('errors.event_type.datetime_past'))
    end

    def event
      @event ||= Event.find(event_id)
    end
  end
end
