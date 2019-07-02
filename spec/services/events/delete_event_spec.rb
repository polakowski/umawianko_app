describe Events::DeleteEvent, type: :service do
  describe '.call' do
    it 'deletes event' do
      event = create(:event)

      expect {
        Events::DeleteEvent.call(event)
      }.to change {
        event.deleted?
      }.from(false).to(true)
    end

    context 'when event type is blank' do
      it 'does not send slack notification' do
        allow(Slack::SendNotification).to receive(:call)
        event = create(:event)

        Events::DeleteEvent.call(event)

        expect(Slack::SendNotification).not_to have_received(:call)
      end
    end

    context 'when event type does not contain slack webhook' do
      it 'does not send slack notification' do
        allow(Slack::SendNotification).to receive(:call)
        event = create(:event, :with_type)

        Events::DeleteEvent.call(event)

        expect(Slack::SendNotification).not_to have_received(:call)
      end
    end

    context 'when event type contains slack webhook' do
      it 'does not send slack notification' do
        allow(Slack::SendNotification).to receive(:call)
        event_type = create(:event_type, slack_webhook: 'http://hook.com/abc', color: '#abc')
        event = create(:event, event_type: event_type)

        Events::DeleteEvent.call(event)

        expect(Slack::SendNotification).to have_received(:call)
          .once
          .with('http://hook.com/abc', '#abc')
      end
    end
  end
end
