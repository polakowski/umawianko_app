class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', inverse_of: :created_events
  has_many :event_users, dependent: :restrict_with_exception
  has_many :users_joined, through: :event_users, source: :user
  belongs_to :event_type, inverse_of: :events

  scope :newest_first, -> { order(:datetime) }
  scope :upcoming, -> { where('datetime > ?', Time.zone.now) }
  scope :of_event_type_id, ->(param) { where(event_type_id: param) }
  scope :past, -> { where('datetime < ?', Time.zone.now) }

  delegate :past?,
           :future?,
           to: :datetime,
           allow_nil: true

  def participants_count
    users_joined.count + friends_count
  end

  def friends_count
    event_users.pluck(:friends_count).sum
  end

  def permalink
    "#{ENV['DOMAIN_NAME']}/events/#{id}"
  end
end
