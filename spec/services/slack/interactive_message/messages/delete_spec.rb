describe Slack::InteractiveMessage::Messages::Delete do
  context '.call' do
    it 'sends response' do
      message = double('ActiveSupport::OrderedOptions')
      allow(message).to receive(:delete_original=)
      allow(Slack::SendResponse).to(
        receive(:call).with('https://example.com/webhook').and_yield(message)
      )

      payload = {
        response_url: 'https://example.com/webhook',
        actions: [
          {
            name: 'messages.delete'
          }
        ]
      }

      Slack::InteractiveMessage::Messages::Delete.call(payload)

      expect(Slack::SendResponse).to have_received(:call).once.with('https://example.com/webhook')
      expect(message).to have_received(:delete_original=).once.with(true)
    end
  end
end
