module Slack
  class InteractionObject < Struct.new(:action, :value, :state, :trigger_id)
  end
end
