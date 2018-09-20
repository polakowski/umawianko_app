describe Slack::SendResponse do
  context 'if slack webhook is not provided' do
    it 'raises error' do
      expect {
        Slack::SendResponse.call('')
      }.to raise_error(Umawianko::RuntimeError)
    end
  end

  context 'if provided data is valid' do
    it 'sends notification using slack-notifier gem' do
      notifier = instance_double(Slack::Notifier)
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
      allow(notifier).to receive(:post)

      Slack::SendResponse.call('http://example.com/webhook') do |msg|
        msg.text = 'This is text.'
      end

      expect(notifier).to have_received(:post).with(
        include(
          text: 'This is text.',
          response_type: 'ephemeral',
          replace_original: false
        )
      )
    end

    it 'yields the message' do
      notifier = instance_double(Slack::Notifier)
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
      allow(notifier).to receive(:post)

      expect { |b|
        Slack::SendResponse.call('http://example.com/webhook', &b)
      }.to yield_control.once
    end
  end
end
