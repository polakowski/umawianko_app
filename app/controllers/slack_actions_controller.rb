class SlackActionsController < ActionController::Base
  rescue_from Umawianko::InvalidSlackInteraction do |error|
    respond_to_user('Something went wrong.')
  end

  rescue_from Umawianko::SlackInteractionUserNotFound do
    respond_to_user('Your account is not connected. Visit UmawiankoApp and create account.')
  end

  def handle
    Slack::HandleInteraction.call(
      interaction,
      slack_user_id,
      callback_webhook
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

  def interaction_params
    payload.dig('actions', 0)
  end

  def slack_user_id
    payload.dig('user', 'id')
  end

  def callback_webhook
    payload.dig('response_url')
  end
end
