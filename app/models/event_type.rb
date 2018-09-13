class EventType < ApplicationRecord
  DEFAULT_ICON = 'event-checkmark'.freeze
  DEFAULT_COLOR = '#8e8e8e'.freeze

  has_many :events, dependent: :nullify

  def color_or_default
    color.presence || DEFAULT_COLOR
  end
end
