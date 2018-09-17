module Slack
  class HandleInteraction < ApplicationService
    def initialize(interaction, slack_user_id, callback_webhook, trigger_id)
      @interaction = interaction
      @slack_user_id = slack_user_id
      @callback_webhook = callback_webhook
      @trigger_id = trigger_id
    end

    def call
      handle_interaction && interaction_success
    end

    private

    attr_reader :interaction,
                :slack_user_id,
                :callback_webhook,
                :trigger_id

    def user_email
      @user_email ||= Slack::Wrapper.user_id_to_email(slack_user_id)
    end

    def user
      @user ||= User.find_by(email: user_email).tap do |user|
        raise(Umawianko::SlackInteractionUserNotFound, 'User not found') unless user
      end
    end

    def handle_interaction
      case interaction.name
      when 'events.join_solo'
        @event = Event.find(interaction.value)
        Events::JoinEvent.call(@event, user)
      when 'messages.delete'
        true
      when 'events.join_with_friends'
        @event = Event.find(interaction.value)
        true
      when 'events.submit_join_dialog'
        @event = Event.find(interaction.value.state)
        Events::JoinEvent.call(@event, user, interaction.value.friends_count)
      end
    end

    def interaction_success
      case interaction.name
      when 'events.join_solo'
        send_response do |msg|
          msg.replace_original = false
          msg.response_type = 'ephemeral'
          msg.attachments = [
            {
              title: "You have signed up for <#{@event.permalink}|#{@event.name}>.",
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
      when 'events.join_with_friends'
        Slack::Wrapper.open_dialog(
          trigger_id,
          callback_id: 'events.submit_join_dialog',
          title: "Join \"#{@event.name}\"".truncate(24),
          submit_label: 'Submit',
          notify_on_cancel: false,
          state: @event.id.to_s,
          elements: [
            {
              type: 'text',
              label: 'No. of friends',
              name: 'friends_count',
              hint: 'How many friends will you bring?'
            }
          ]
        )
      when 'events.submit_join_dialog'
        send_response do |msg|
          msg.replace_original = false
          msg.response_type = 'ephemeral'
          msg.attachments = [
            {
              title: "You have signed up for <#{@event.permalink}|#{@event.name}>. "\
                "You will bring #{interaction.value.friends_count} friends.",
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
      when 'messages.delete'
        send_response do |msg|
          msg.delete_original = true
        end
      end
    end

    def send_response
      Slack::SendResponse.call(callback_webhook) do |msg|
        yield msg if block_given?
      end
    end
  end
end
