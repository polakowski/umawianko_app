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

  def event_type_bg_color(event)
    event.event_type.color.presence || EventType::DEFAULT_COLOR
  end

  def event_circle_icon(event)
    event.event_type.icon.presence || EventType::DEFAULT_ICON
  end
end
