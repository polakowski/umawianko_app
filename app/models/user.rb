class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable

  has_many :created_events, class_name: Event, foreign_key: :creator_id, inverse_of: :creator

  def self.create_with_omniauth(auth)
    user = User.new
    Users::GoogleOAuthCreateUser.call(user, auth)
    user
  end
end
