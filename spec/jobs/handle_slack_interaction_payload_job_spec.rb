describe HandleSlackInteractionPayloadJob do
  context '#perform' do
    it 'calls service with given param' do
      payload = double('payload')
      allow(Slack::HandleInteractionPayload).to receive(:call)

      HandleSlackInteractionPayloadJob.new.perform(payload)

      expect(Slack::HandleInteractionPayload).to have_received(:call).once.with(payload)
    end
  end
end
