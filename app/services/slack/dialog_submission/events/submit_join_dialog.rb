module Slack
  module DialogSubmission
    module Events
      class SubmitJoinDialog < Slack::DialogSubmission::BaseHandler
        include ActionView::Helpers::TextHelper

        def setup
          @event = Event.find(interaction.state)
        end

        def perform_action
          @event_user = ::Events::JoinEvent.call(
            event, user, interaction.value[:friends_count]
          ).result
        end

        def send_response
          # event_user = EventUser.find_by(event: event, user: user)

          Slack::SendResponse.call(callback_webhook) do |msg|
            msg.attachments = [
              {
                title: "You have signed up for <#{event.permalink}|#{event.name}>. "\
                  "You will bring #{pluralize(@event_user.friends_count, 'friend')}.",
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

        attr_reader :event, :event_user
      end
    end
  end
end
