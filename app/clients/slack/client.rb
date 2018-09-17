module Slack
  class Client < ApplicationClient
    base_url 'https://slack.com'

    def get_user_info(user_id)
      body     = { token: access_token, user: user_id }
      response = get('/api/users.info', params: body)

      handle_response(response, 'user')
    end

    private

    def access_token
      ENV.fetch('SLACK_APP_ACCESS_TOKEN')
    end
  end
end
