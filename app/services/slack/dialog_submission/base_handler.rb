module Slack
  module DialogSubmission
    class BaseHandler < Slack::BaseMessageHandler
      private

      def build_interaction_object
        Slack::InteractionObject.new.tap do |obj|
          obj.action = payload[:callback_id]
          obj.value = payload[:submission]
          obj.state = payload[:state]
          obj.trigger_id = payload[:trigger_id]
        end
      end
    end
  end
end
