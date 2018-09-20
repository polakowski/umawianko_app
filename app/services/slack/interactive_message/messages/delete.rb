module Slack
  module InteractiveMessage
    module Messages
      class Delete < Slack::InteractiveMessage::BaseHandler
        def perform_action
          true
        end

        def send_response
          Slack::SendResponse.call(callback_webhook) do |msg|
            msg.delete_original = true
          end
        end

        private

        attr_reader :event
      end
    end
  end
end
