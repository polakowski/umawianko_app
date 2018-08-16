class EventsController < AuthenticatedController
  def index
    @events = Event.upcoming
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new
  end
end
