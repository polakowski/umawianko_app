class SlackActionsController < ActionController::Base
  INTERACTION = 'interactive_message'.freeze
  DIALOG_RESULT = 'dialog_submission'.freeze

  rescue_from Umawianko::InvalidSlackInteraction do
    respond_to_user('Something went wrong.')
  end

  rescue_from Umawianko::SlackInteractionUserNotFound do
    respond_to_user('Your account is not connected. Visit UmawiankoApp and create account.')
  end

  def handle
    Slack::HandleInteraction.call(
      interactive_action_object,
      slack_user_id,
      callback_webhook,
      trigger_id
    )
  end

  private

  def payload
    JSON.parse(params.require(:payload))
  end

  def respond_with_object(object)
    respond_to_user(object.text)
  end

  def respond_to_user(text)
    render json: {
      response_type: 'ephemeral',
      replace_original: false,
      text: text
    }
  end

  def interaction
    @interaction ||= OpenStruct.new(interaction_params)
  end

  def dialog_submission
    @dialog_submission ||= OpenStruct.new(
      name: payload['callback_id'],
      value: OpenStruct.new(payload['submission'].merge('state' => payload['state']))
    )
  end

  def submission_value
    payload['submission'].merge('state' => payload['state'])
  end

  def request_type
    payload.dig('type')
  end

  def interaction_params
    payload.dig('actions', 0)
  end

  def slack_user_id
    payload.dig('user', 'id')
  end

  def callback_webhook
    payload.dig('response_url')
  end

  def trigger_id
    payload.dig('trigger_id')
  end

  def interactive_action_object
    case request_type
    when INTERACTION
      interaction
    when DIALOG_RESULT
      dialog_submission
    end
  end
end
