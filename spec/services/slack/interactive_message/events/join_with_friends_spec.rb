describe Slack::InteractiveMessage::Events::JoinWithFriends do
  describe '.call' do
    it 'calls open_dialog wrapper method' do
      event = create(:upcoming_event, name: 'Oh My God This Name Is So Long')
      allow(Slack::Wrapper).to receive(:open_dialog)

      payload = {
        response_url: 'https://example.com/webhook',
        actions: [
          {
            name: 'events.join_with_friends',
            value: event.id
          }
        ],
        trigger_id: 'abc-123'
      }

      Slack::InteractiveMessage::Events::JoinWithFriends.call(payload)

      expect(Slack::Wrapper).to have_received(:open_dialog).once.with(
        'abc-123',
        include(
          callback_id: 'events.submit_join_dialog',
          title: 'Join "Oh My God This..."',
          submit_label: 'Submit',
          notify_on_cancel: false,
          state: event.id,
          elements: [
            include(
              type: 'text',
              label: 'No. of friends',
              name: 'friends_count',
              hint: 'How many friends will you bring?'
            )
          ]
        )
      )
    end
  end
end
