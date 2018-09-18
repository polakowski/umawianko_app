module Slack
  module InteractiveMessage
    module Events
      class JoinWithFriends < Slack::InteractiveMessage::BaseHandler
        def setup
          @event = Event.find(interaction.value)
        end

        def perform_action
          true
        end

        def send_response
          Slack::Wrapper.open_dialog(
            interaction.trigger_id,
            callback_id: 'events.submit_join_dialog',
            title: "Join \"#{event.name.truncate(17)}\"", # max title length is 24
            submit_label: 'Submit',
            notify_on_cancel: false,
            state: event.id,
            elements: [
              {
                type: 'text',
                label: I18n.t('simple_form.labels.event_user.friends_count'),
                name: 'friends_count',
                hint: I18n.t('simple_form.hints.event_user.friends_count')
              }
            ]
          )
        end

        private

        attr_reader :event
      end
    end
  end
end
