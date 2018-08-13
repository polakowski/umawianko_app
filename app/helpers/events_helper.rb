module EventsHelper
  def format_event_date(event)
    event.datetime.strftime('%F')
  end
end
