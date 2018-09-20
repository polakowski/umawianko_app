module Slack
  module InteractiveMessage
    class BaseHandler < Slack::BaseMessageHandler
      private

      def build_interaction_object
        Slack::InteractionObject.new.tap do |obj|
          obj.action = action_params[:name]
          obj.value = action_params[:value]
          obj.trigger_id = payload[:trigger_id]
        end
      end

      def action_params
        payload.dig(:actions, 0)
      end
    end
  end
end
