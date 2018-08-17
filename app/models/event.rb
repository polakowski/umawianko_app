class Event < ApplicationRecord
  scope :upcoming, -> { where('datetime > ?', Time.zone.now).order(:datetime) }

  belongs_to :creator, class_name: User, inverse_of: :created_events
end
