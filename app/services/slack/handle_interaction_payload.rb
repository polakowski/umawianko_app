module Slack
  class HandleInteractionPayload < ApplicationService
    TYPE_INTERACTIVE_MESSAGE = 'interactive_message'.freeze
    TYPE_DIALOG_SUBMISSION = 'dialog_submission'.freeze

    def initialize(payload)
      @payload = payload.deep_symbolize_keys
    end

    def call
      endpoint_handler_class.call(payload)
    end

    private

    attr_reader :payload

    def payload_type
      payload[:type]
    end

    def full_action_name
      @full_action_name ||= begin
        result = case payload_type
                 when TYPE_INTERACTIVE_MESSAGE
                   payload.dig(:actions, 0, :name)
                 when TYPE_DIALOG_SUBMISSION
                   payload.dig(:callback_id)
                 else
                   raise Umawianko::InvalidSlackInteraction, 'Unrecognized payload type'
                 end

        result || raise(Umawianko::InvalidSlackInteraction, 'Cannot fetch action name')
      end
    end

    def payload_group
      full_action_name.split('.').first
    end

    def short_action_name
      full_action_name.split('.').last
    end

    def endpoint_handler_class
      name = "slack/#{payload_type}/#{payload_group}/#{short_action_name}".camelize
      name.constantize
    rescue NameError
      raise Umawianko::InvalidSlackInteraction, "Invalid endpoint handler class #{name}"
    end
  end
end
