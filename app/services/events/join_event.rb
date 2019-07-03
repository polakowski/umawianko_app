module Events
  class JoinEvent < ApplicationService
    def initialize(event, user, friends_count = 0)
      @event = event
      @user = user
      @friends_count = friends_count.to_i
    end

    def call
      raise(Umawianko::RuntimeError, 'cannot join past event') if @event.past?
      create_or_update_event_user
    end

    private

    attr_reader :event, :user, :friends_count

    def create_or_update_event_user
      EventUser.with_deleted.find_or_initialize_by(event: event, user: user).tap do |event_user|
        event_user.restore if event_user.deleted?
        event_user.friends_count = friends_count
        event_user.save!
      end
    end
  end
end
