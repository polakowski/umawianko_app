module EventsHelper
  def format_event_date(event)
    event.datetime.strftime('%F')
  end

  def format_event_time(event)
    event.datetime.strftime('%R')
  end

  def format_event_date_and_time(event)
    "#{format_event_date(event)} #{format_event_time(event)}"
  end

  def format_event_people_hint(event)
    "(#{event.users_joined.count} + #{pluralize(event.friends_count, 'friend')})"
  end
end
