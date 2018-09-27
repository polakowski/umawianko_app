class HandleSlackInteractionPayloadJob < ApplicationJob
  def perform(payload)
    Slack::HandleInteractionPayload.call(payload)
  end
end
