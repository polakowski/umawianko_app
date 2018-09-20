module Support
  module SignedInAs
    def signed_in_as(user)
      page.set_rack_session(user_uid: user.uid)
    end
  end
end

RSpec.configure do |config|
  config.include Support::SignedInAs
end
