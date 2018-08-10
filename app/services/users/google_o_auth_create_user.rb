module Users
  class GoogleOAuthCreateUser
    def self.call(user, auth)
      new.call(user, auth)
    end

    def call(user, auth)
      @user = user
      @auth = auth
      create_user
    end

    private

    attr_reader :user, :auth

    def create_user
      user.uid = auth['uid']
      user.name = fetch_info('name')
      user.email = fetch_info('email')
      user.image = fetch_info('image')
      user.save!
    end

    def fetch_info(attribute)
      auth['info'][attribute] || ''
    end
  end
end
