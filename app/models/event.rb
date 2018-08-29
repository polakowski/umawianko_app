class Event < ApplicationRecord
  scope :upcoming, -> { where('datetime > ?', Time.zone.now).order(:datetime) }

  belongs_to :creator, class_name: 'User', inverse_of: :created_events
  has_many :event_users
  has_many :participants, through: :event_users, source: :user
end
