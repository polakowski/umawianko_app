describe Slack::DialogSubmission::Events::SubmitJoinDialog do
  describe '.call' do
    context 'when user account connected' do
      context 'when correct friends_count value provided' do
        it 'calls join_event service' do
          event      = create(:upcoming_event)
          user       = create(:user, email: 'user@example.com')
          event_user = create(:event_user, event: event, user: user, friends_count: 5)
          join_event = double('Events::JoinEvent')
          wrapper    = double('Slack::Wrapper')

          allow(join_event).to receive(:result).and_return(event_user)
          allow(Events::JoinEvent).to receive(:call).and_return(join_event)
          allow(Slack::SendResponse).to receive(:call)
          allow(wrapper).to(
            receive(:user_id_to_email).with('A1').and_return('user@example.com')
          )

          stub_const('Slack::Wrapper', wrapper)

          payload = {
            response_url: 'https://example.com/webhook',
            user: {
              id: 'A1'
            },
            submission: {
              friends_count: 5
            },
            state: event.id
          }

          Slack::DialogSubmission::Events::SubmitJoinDialog.call(payload)

          expect(Events::JoinEvent).to have_received(:call).once.with(event, user, 5)
        end

        it 'sends response' do
          event      = create(:upcoming_event, name: 'FooBarBaz')
          user       = create(:user, email: 'user@example.com')
          event_user = create(:event_user, event: event, user: user, friends_count: 2)
          message    = double('ActiveSupport::OrderedOptions')
          join_event = double('Events::JoinEvent')
          wrapper    = double('Slack::Wrapper')

          allow(message).to receive(:attachments=)
          allow(join_event).to receive(:result).and_return(event_user)
          allow(Events::JoinEvent).to receive(:call).and_return(join_event)
          allow(Slack::SendResponse).to receive(:call).and_yield(message)
          allow(wrapper).to(
            receive(:user_id_to_email).with('A1').and_return('user@example.com')
          )

          stub_const('Slack::Wrapper', wrapper)
          stub_env('DOMAIN_NAME', 'http://foo.eu')

          payload = {
            response_url: 'https://example.com/webhook',
            user: {
              id: 'A1'
            },
            submission: {
              friends_count: 2
            },
            state: event.id
          }

          Slack::DialogSubmission::Events::SubmitJoinDialog.call(payload)

          expect(Slack::SendResponse).to(
            have_received(:call).once.with('https://example.com/webhook')
          )
          expect(message).to have_received(:attachments=).once.with(
            include(
              title: "You have signed up for <http://foo.eu/events/#{event.id}|FooBarBaz>. "\
                'You will bring 2 friends.',
              callback_id: 'event_joined',
              actions: [{
                name: 'messages.delete',
                text: 'I got it.',
                type: 'button',
                style: 'default'
              }]
            )
          )
        end
      end

      context 'when incorrect friends_count value provided' do
        it 'calls join_event service' do
          event      = create(:upcoming_event)
          user       = create(:user, email: 'user@example.com')
          message    = double('ActiveSupport::OrderedOptions')
          event_user = create(:event_user, event: event, user: user)
          wrapper    = double('Slack::Wrapper')
          join_event = double('Events::JoinEvent')

          allow(message).to receive(:attachments=)
          allow(join_event).to receive(:result).and_return(event_user)
          allow(Events::JoinEvent).to receive(:call).and_return(join_event)
          allow(Slack::SendResponse).to receive(:call).and_yield(message)
          allow(wrapper).to(
            receive(:user_id_to_email).with('B8').and_return('user@example.com')
          )

          stub_const('Slack::Wrapper', wrapper)

          payload = {
            response_url: 'https://example.com/webhook',
            user: {
              id: 'B8'
            },
            submission: {
              friends_count: 'NaN'
            },
            state: event.id
          }

          Slack::DialogSubmission::Events::SubmitJoinDialog.call(payload)

          expect(Events::JoinEvent).to have_received(:call).once.with(event, user, 'NaN')
        end
      end
    end

    context 'when no user account connected' do
      it 'raises error' do
        event   = create(:upcoming_event)
        wrapper = double('Slack::Wrapper')

        allow(wrapper).to(
          receive(:user_id_to_email).with('DLG123').and_return('gregory@home.com')
        )

        stub_const('Slack::Wrapper', wrapper)

        payload = {
          response_url: 'https://example.com/webhook',
          user: {
            id: 'DLG123'
          },
          submission: {
            friends_count: 3
          },
          state: event.id
        }

        expect {
          Slack::DialogSubmission::Events::SubmitJoinDialog.call(payload)
        }.to raise_error(
          Umawianko::SlackInteractionUserNotFound, 'User not found: gregory@home.com'
        )
      end
    end
  end
end
