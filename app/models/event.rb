class Event < ApplicationRecord
  DEFAULT_ICON = 'checkmark'.freeze

  scope :upcoming, -> { where('datetime > ?', Time.zone.now).order(:datetime) }

  belongs_to :creator, class_name: 'User', inverse_of: :created_events
  has_many :event_users, dependent: :destroy
  has_many :users_joined, through: :event_users, source: :user
  belongs_to :event_type, inverse_of: :events

  def participants_count
    users_joined.count + friends_count
  end

  def friends_count
    event_users.pluck(:friends_count).sum
  end

  def permalink
    "#{ENV['HOST']}/events/#{id}"
  end
end
