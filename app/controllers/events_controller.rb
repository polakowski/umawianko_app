class EventsController < AuthenticatedController
  def index
    @events = Event.upcoming
  end
end
