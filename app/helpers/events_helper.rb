module EventsHelper
  def format_event_date(event)
    event.datetime.strftime('%F')
  end

  def format_event_time(event)
    event.datetime.strftime('%R')
  end

  def format_event_people(event)
    <<-STRING.squish
      #{event.participants_count} total
      (#{event.users_joined.count} + #{event.friends_count} friends)
    STRING
  end
end
