module Slack
  module InteractionPayloadValidation
    ALLOWED_ACTIONS = %w[
      events.join_solo
      events.join_with_friends
      events.submit_join_dialog
      messages.delete
    ].freeze

    def validate_payload!
      validate_full_action_name!
    end

    def validate_full_action_name!
      return true if full_action_name.in?(ALLOWED_ACTIONS)
      raise(Umawianko::InvalidSlackInteraction, "Action not allowed: #{full_action_name}")
    end
  end
end
