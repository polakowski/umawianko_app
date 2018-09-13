class User < ApplicationRecord
  devise :database_authenticatable, :rememberable

  has_many :created_events,
           class_name: 'Event',
           foreign_key: :creator_id,
           inverse_of: :creator,
           dependent: :restrict_with_exception
  has_many :event_users, inverse_of: :user, dependent: :restrict_with_exception
  has_many :joined_events, through: :event_users, source: :event

  def self.create_with_omniauth(auth)
    user = User.new
    Users::GoogleOAuthCreateUser.call(user, auth)
    user
  end

  def to_s
    name.presence || email
  end
end
