class Event < ApplicationRecord
  scope :upcoming, -> { where('datetime > ?', Time.zone.now).order(:datetime) }
end
