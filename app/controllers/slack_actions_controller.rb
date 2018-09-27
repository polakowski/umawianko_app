class SlackActionsController < ActionController::Base
  rescue_from Umawianko::InvalidSlackInteraction do
    respond_to_user('Something went wrong.')
  end

  rescue_from Umawianko::SlackInteractionUserNotFound do
    respond_to_user('Your account is not connected. Visit UmawiankoApp and create account.')
  end

  def handle
    HandleSlackInteractionPayloadJob.perform_async(payload).tap do |job_id|
      raise Umawianko::InvalidSlackInteraction if job_id.blank?
    end

    head :no_content
  end

  private

  def payload
    JSON.parse(params.require(:payload))
  end

  def respond_to_user(text)
    render json: {
      response_type: 'ephemeral',
      replace_original: false,
      text: text
    }
  end
end
