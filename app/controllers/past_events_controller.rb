class PastEventsController < EventsController
  PAGE_SIZE = 20

  def index
    @pagy, @events = pagy(events_scope, items: PAGE_SIZE)
  end

  private

  def events_scope
    Event.past.newest_last
  end
end
