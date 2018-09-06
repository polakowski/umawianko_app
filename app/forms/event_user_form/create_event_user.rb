module EventUserForm
  class CreateEventUser < EventUserForm::Base
    attribute :event_id, Integer
    attribute :friends_count, Integer

    validates :friends_count, presence: true
    validate :friends_count_numericality

    private

    def persist
      join_event
    end

    def join_event
      event = Event.find(event_id)
      @resource = Events::JoinEvent.call(event, form_owner, friends_count).result
    end

    def friends_count_numericality
      return true if (0..100).cover? friends_count
      errors.add(:friends_count, 'is invalid')
    end
  end
end
