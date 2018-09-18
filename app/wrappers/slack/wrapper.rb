module Slack
  class Wrapper < ApplicationWrapper
    client_class Slack::Client

    def user_id_to_email(user_id)
      user = client.get_user_info(user_id)
      user.dig('profile', 'email') if user.present?
    end

    def open_dialog(trigger_id, dialog = {})
      client.send_dialog_open_request(trigger_id, dialog)
    end
  end
end
