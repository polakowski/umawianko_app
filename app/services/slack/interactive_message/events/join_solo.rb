module Slack
  module InteractiveMessage
    module Events
      class JoinSolo < Slack::InteractiveMessage::BaseHandler
        def setup
          @event = Event.find(interaction.value)
        end

        def perform_action
          ::Events::JoinEvent.call(event, user)
        end

        def send_response
          Slack::SendResponse.call(callback_webhook) do |msg|
            msg.replace_original = false
            msg.response_type = 'ephemeral'
            msg.attachments = [
              {
                title: "You have signed up for <#{event.permalink}|#{event.name}>.",
                callback_id: 'event_joined',
                actions: [{
                  name: 'messages.delete',
                  text: 'I got it.',
                  type: 'button',
                  style: 'default'
                }]
              }
            ]
          end
        end

        private

        attr_reader :event
      end
    end
  end
end
