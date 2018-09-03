module Support
  module SignedInAs
    def signed_in_as(user)
      page.set_rack_session(user_id: user.id)
    end
  end
end

RSpec.configure do |config|
  config.include Support::SignedInAs
end
