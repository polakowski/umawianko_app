module Slack
  class Client < ApplicationClient
    base_url 'https://slack.com'

    def get_user_info(user_id)
      body     = { token: access_token, user: user_id }
      response = get('/api/users.info', params: body)

      handle_response(response, 'user')
    end

    def send_dialog_open_request(trigger_id, dialog = {})
      body     = { token: access_token, trigger_id: trigger_id, dialog: dialog.to_json }
      response = get('/api/dialog.open', params: body)

      handle_response(response)
    end

    private

    def access_token
      ENV.fetch('SLACK_APP_ACCESS_TOKEN')
    end

    def default_content_types
      {
        get: 'application/x-www-form-urlencoded, charset=utf-8'
      }
    end
  end
end
