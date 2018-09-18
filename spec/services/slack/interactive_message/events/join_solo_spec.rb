describe Slack::InteractiveMessage::Events::JoinSolo do
  describe '.call' do
    context 'with user account connected' do
      it 'calls join_event service' do
        user    = create(:user, email: 'john@doe.com')
        event   = create(:upcoming_event, name: 'The Event')
        wrapper = double('Slack::Wrapper')

        allow(Events::JoinEvent).to receive(:call)
        allow(wrapper).to(
          receive(:user_id_to_email).with('ABC123').and_return('john@doe.com')
        )

        stub_const('Slack::Wrapper', wrapper)

        payload = {
          response_url: 'https://example.com/webhook',
          user: {
            id: 'ABC123'
          },
          actions: [
            {
              name: 'events.join_solo',
              value: event.id
            }
          ]
        }

        Slack::InteractiveMessage::Events::JoinSolo.call(payload)

        expect(Events::JoinEvent).to have_received(:call).once.with(event, user)
      end

      it 'sends response' do
        create(:user, email: 'john@doe.com')

        event   = create(:upcoming_event, name: 'The Event')
        message = double('ActiveSupport::OrderedOptions')
        wrapper = double('Slack::Wrapper')

        allow(message).to receive(:attachments=)
        allow(wrapper).to(
          receive(:user_id_to_email).with('ABC123').and_return('john@doe.com')
        )
        allow(Slack::SendResponse).to(
          receive(:call).with('https://example.com/webhook').and_yield(message)
        )

        stub_const('Slack::Wrapper', wrapper)
        stub_env('DOMAIN_NAME', 'http://foo.bar')

        payload = {
          response_url: 'https://example.com/webhook',
          user: {
            id: 'ABC123'
          },
          actions: [
            {
              name: 'events.join_solo',
              value: event.id
            }
          ]
        }

        Slack::InteractiveMessage::Events::JoinSolo.call(payload)

        expect(Slack::SendResponse).to have_received(:call).once.with('https://example.com/webhook')
        expect(message).to have_received(:attachments=).once.with([
          include(
            title: "You have signed up for <http://foo.bar/events/#{event.id}|The Event>.",
            callback_id: 'event_joined',
            actions: [
              include(
                name: 'messages.delete',
                text: 'I got it.',
                type: 'button',
                style: 'default'
              )
            ]
          )
        ])
      end
    end

    context 'when no user account connected' do
      it 'raises error' do
        create(:user, email: 'elon@space.com')

        event   = create(:upcoming_event)
        wrapper = double('Slack::Wrapper')

        allow(wrapper).to(
          receive(:user_id_to_email).with('OCISLY').and_return('jeff@blue.com')
        )

        stub_const('Slack::Wrapper', wrapper)

        payload = {
          response_url: 'https://example.com/webhook',
          user: {
            id: 'OCISLY'
          },
          actions: [
            {
              name: 'events.join_solo',
              value: event.id
            }
          ]
        }

        expect {
          Slack::InteractiveMessage::Events::JoinSolo.call(payload)
        }.to raise_error(
          Umawianko::SlackInteractionUserNotFound, 'User not found: jeff@blue.com'
        )
      end
    end
  end
end
