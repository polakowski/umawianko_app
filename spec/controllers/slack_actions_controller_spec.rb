describe SlackActionsController, type: :controller do
  describe '#handle' do
    it 'calls the service and renders nothing' do
      allow(Slack::HandleInteractionPayload).to receive(:call)
      params = slack_interaction_params(
        type: 'dialog_submission',
        submission: {
          one: '1',
          two: 2,
          three: 'zzz'
        }
      )

      get :handle, params: params

      expect(response).to be_no_content
      expect(response.body).to be_empty
      expect(Slack::HandleInteractionPayload).to have_received(:call).once.with(
        include(
          'type' => 'dialog_submission',
          'submission' => include(
            'one' => '1',
            'two' => 2,
            'three' => 'zzz'
          )
        )
      )
    end
  end

  def slack_interaction_params(payload)
    {
      payload: payload.to_json
    }
  end
end
