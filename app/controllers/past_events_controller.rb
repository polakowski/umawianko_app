class PastEventsController < EventsController
  PAGE_SIZE = 15

  private

  def events_scope
    Event.past.newest_first.page(params[:p]).per(PAGE_SIZE)
  end
end
