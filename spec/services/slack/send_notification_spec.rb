describe Slack::SendNotification do
  context 'if slack webhook is not provided' do
    it 'raises error' do
      expect {
        Slack::SendNotification.call('')
      }.to raise_error(Umawianko::RuntimeError)
    end
  end

  context 'if provided color is invalid' do
    it 'raises error' do
      expect {
        Slack::SendNotification.call('http://example.com/webhook', :invalid_color)
      }.to raise_error(Umawianko::RuntimeError)
    end
  end

  context 'if provided data is valid' do
    it 'sends notification using slack-notifier gem' do
      notifier = instance_double(Slack::Notifier)
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
      allow(notifier).to receive(:post)

      Slack::SendNotification.call('http://example.com/webhook') do |msg|
        msg.fallback = 'Notification.'
        msg.title = 'Lorem ipsum'
        msg.text = 'Dolor sit amet'
        msg.fields = [{ title: 'Foo', value: 'Bar', short: true }]
        msg.footer = 'Footer content'
      end

      expect(notifier).to have_received(:post).with(
        attachments: include(
          fallback: 'Notification.',
          color: '#00a1ff',
          title: 'Lorem ipsum',
          text: 'Dolor sit amet',
          fields: include(title: 'Foo', value: 'Bar', short: true),
          footer: 'Footer content'
        )
      )
    end
  end
end
