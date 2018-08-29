class Event < ApplicationRecord
  scope :upcoming, -> { where('datetime > ?', Time.zone.now).order(:datetime) }

  belongs_to :creator, class_name: 'User', inverse_of: :created_events
  has_many :event_users
  has_many :users_joined, through: :event_users, source: :user

  def participants_count
    users_joined.count + friends_count
  end

  def friends_count
    event_users.pluck(:friends_count).sum
  end
end
