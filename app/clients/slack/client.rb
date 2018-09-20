module Slack
  class Client < ApplicationClient
    base_url 'https://slack.com'

    def get_user_info(user_id)
      get(
        '/api/users.info',
        content_type: 'application/x-www-form-urlencoded, charset=utf-8',
        root_key: 'user',
        params: {
          token: access_token,
          user: user_id
        }
      )
    end

    def send_dialog_open_request(trigger_id, dialog = {})
      get(
        '/api/dialog.open',
        content_type: 'application/x-www-form-urlencoded, charset=utf-8',
        params: {
          token: access_token,
          trigger_id: trigger_id,
          dialog: dialog.to_json
        }
      )
    end

    private

    def access_token
      ENV.fetch('SLACK_APP_ACCESS_TOKEN')
    end
  end
end
