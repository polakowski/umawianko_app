describe Slack::HandleInteractionPayload do
  describe '.call' do
    context 'when no payload type is passed' do
      it 'raises error' do
        payload = {
          actions: [
            {
              name: 'events.join_solo',
              type: 'button',
              value: '1'
            }
          ]
        }

        expect {
          Slack::HandleInteractionPayload.call(payload)
        }.to raise_error(Umawianko::InvalidSlackInteraction, 'Unrecognized payload type')
      end
    end

    context 'when interactive_message payload is passed' do
      context 'when action name is not present in payload' do
        it 'raises error' do
          payload = {
            type: 'interactive_message',
            actions: [
              {
                type: 'button',
                value: '1'
              }
            ]
          }

          expect {
            Slack::HandleInteractionPayload.call(payload)
          }.to raise_error(Umawianko::InvalidSlackInteraction, 'Cannot fetch action name')
        end
      end

      context 'when no handler class is implemented' do
        it 'raises error' do
          payload = {
            type: 'interactive_message',
            actions: [
              {
                name: 'foos.process',
                type: 'button',
                value: '1'
              }
            ]
          }

          expect {
            Slack::HandleInteractionPayload.call(payload)
          }.to raise_error(
            Umawianko::InvalidSlackInteraction,
            'Invalid endpoint handler class Slack::InteractiveMessage::Foos::Process'
          )
        end
      end

      context 'when the payload is correct' do
        it 'calls correct handler service' do
          handler = double('handler')
          allow(handler).to receive(:call)
          stub_const('Slack::InteractiveMessage::Foobars::Baz', handler)

          payload = {
            type: 'interactive_message',
            actions: [
              {
                name: 'foobars.baz',
                type: 'button',
                value: '1'
              }
            ]
          }

          Slack::HandleInteractionPayload.call(payload)

          expect(handler).to have_received(:call).once.with(payload)
        end
      end
    end

    context 'when dialog_submission payload is passed' do
      context 'when action name is not present in payload' do
        it 'raises error' do
          payload = {
            type: 'dialog_submission',
            submission: {
              value: 'abc'
            }
          }

          expect {
            Slack::HandleInteractionPayload.call(payload)
          }.to raise_error(Umawianko::InvalidSlackInteraction, 'Cannot fetch action name')
        end
      end

      context 'when no handler class is implemented' do
        it 'raises error' do
          payload = {
            type: 'dialog_submission',
            submission: {
              value: '123'
            },
            callback_id: 'lorems.ipsum',
            state: 'foo'
          }

          expect {
            Slack::HandleInteractionPayload.call(payload)
          }.to raise_error(
            Umawianko::InvalidSlackInteraction,
            'Invalid endpoint handler class Slack::DialogSubmission::Lorems::Ipsum'
          )
        end
      end

      context 'when the payload is correct' do
        it 'calls correct handler service' do
          handler = double('handler')
          allow(handler).to receive(:call)
          stub_const('Slack::DialogSubmission::Dialogs::Submit', handler)

          payload = {
            type: 'dialog_submission',
            submission: {
              value: '1'
            },
            callback_id: 'dialogs.submit',
            state: 'bar'
          }

          Slack::HandleInteractionPayload.call(payload)

          expect(handler).to have_received(:call).once.with(payload)
        end
      end
    end
  end
end
