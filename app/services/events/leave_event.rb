module Events
  class LeaveEvent < ApplicationService
    def initialize(event_user)
      @event_user = event_user
    end

    def call
      return true if @event_user.deleted?

      @event_user.destroy if can_leave_event?
    end

    private

    attr_reader :event_user

    def can_leave_event?
      event_user.event.future?
    end
  end
end
