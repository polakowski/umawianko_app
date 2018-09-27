module EventsHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::DateHelper

  def format_short_event_date(event)
    event.datetime.strftime('%F')
  end

  def format_event_date(event)
    event.datetime.strftime('%a, %F')
  end

  def format_event_time(event)
    event.datetime.strftime('%R')
  end

  def format_event_date_and_time(event)
    "#{format_event_date(event)} #{format_event_time(event)}"
  end

  def format_event_datetime_with_distance(event)
    prefix = suffix = ''
    css_class = ''

    if event.datetime.past?
      suffix = ' ago'
      css_class += ' text-cancel'
    else
      prefix = 'in '
      css_class += ' text-secondary'
    end

    <<-STRING.squish
      #{format_event_date_and_time(event)}
      #{content_tag(
        :span,
        "(#{prefix}#{distance_of_time_in_words(event.datetime.to_i, Time.zone.now.to_i)}#{suffix})",
        class: css_class
      )}
    STRING
  end

  def format_event_people_hint(event)
    "(#{event.users_joined.count} + #{pluralize(event.friends_count, 'friend')})"
  end

  def event_type_bg_color(event)
    return Event::UNTAGGED_COLOR if event.event_type.nil?
    event.event_type.color.presence || EventType::DEFAULT_COLOR
  end

  def event_circle_icon(event)
    event.event_type&.icon.presence || EventType::DEFAULT_ICON
  end
end
