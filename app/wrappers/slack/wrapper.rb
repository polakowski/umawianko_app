module Slack
  class Wrapper < ::ApplicationWrapper
    client_class Slack::Client

    def user_id_to_email(user_id)
      user = client.get_user_info(user_id)
      user['profile']['email']
    end
  end
end
