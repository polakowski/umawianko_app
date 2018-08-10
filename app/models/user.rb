class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable

  def self.create_with_omniauth(auth)
    user = User.new
    Users::GoogleOAuthCreateUser.call(user, auth)
    user
  end
end
