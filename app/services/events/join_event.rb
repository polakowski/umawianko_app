module Events
  class JoinEvent < ApplicationService
    def initialize(event, user)
      @event = event
      @user = user
    end

    def call
      participant = event.participants.find_by(id: user.id)
      participant.presence || create_event_user
    end

    private

    attr_reader :event, :user

    def create_event_user
      record = EventUser.create!(event: event, user: user)
      record.user
    end
  end
end
