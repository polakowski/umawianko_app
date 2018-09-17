module Slack
  class HandleInteraction < ApplicationService
    def initialize(interaction, slack_user_id, callback_webhook)
      @interaction = interaction
      @slack_user_id = slack_user_id
      @callback_webhook = callback_webhook
    end

    def call
      handle_interaction && interaction_success
    end

    private

    attr_reader :interaction,
                :slack_user_id,
                :callback_webhook

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
        result = Events::JoinEvent.call(@event, user)
      when 'messages.delete'
        true
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
