module Slack
  class BaseMessageHandler < ApplicationService
    ERROR_CLASS = Umawianko::InvalidSlackInteraction

    def initialize(payload)
      @payload = payload
      @interaction = build_interaction_object
      setup
    end

    def call
      perform_action && send_response
    end

    private

    attr_reader :payload, :interaction

    def setup; end

    def perform_action
      raise ERROR_CLASS, "#{self.class} must implement perform_action"
    end

    def send_response
      raise ERROR_CLASS, "#{self.class} must implement send_response"
    end

    def build_interaction_object
      raise ERROR_CLASS, "#{self.class} must implement build_interaction_object"
    end

    def user
      @user ||= find_user
    end

    def find_user
      User.find_by(email: user_email)
    rescue ActiveRecord::RecordNotFound
      raise Umawianko::SlackInteractionUserNotFound, "User not found: #{user_email}"
    end

    def user_email
      @user_email ||= Slack::Wrapper.user_id_to_email(slack_user_identifier)
    end

    def slack_user_identifier
      payload.dig(:user, :id)
    end

    def callback_webhook
      payload.dig(:response_url)
    end
  end
end
