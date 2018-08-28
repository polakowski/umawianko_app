module EventsHelper
  def format_event_date(event)
    event.datetime.strftime('%F')
  end

  def format_event_time(event)
    event.datetime.strftime('%R')
  end
end
