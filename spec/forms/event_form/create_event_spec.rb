describe EventForm::CreateEvent, type: :form do
  describe '#save' do
    context 'when attributes are valid' do
      it 'creates an event' do
        user = create(:user)
        event_type = create(:event_type)
        attrs = attributes_for(:upcoming_event).merge(event_type_id: event_type.id)
        form = EventForm::CreateEvent.new(Event.new, attrs).as(user)

        expect { form.save }.to change { Event.count }.by(1)
      end

      context 'when event_type has slack_webhook set' do
        it 'sends slack notification' do
          user = create(:user)
          event_type = create(:event_type, slack_webhook: 'http://example.com/webhook')
          attrs = attributes_for(:upcoming_event).merge(event_type_id: event_type.id)
          form = EventForm::CreateEvent.new(Event.new, attrs).as(user)
          allow(Slack::SendNotification).to receive(:call)

          form.save

          expect(Slack::SendNotification).to have_received(:call)
            .once.with('http://example.com/webhook')
        end
      end

      context 'when event_type has no slack_webhook' do
        it 'does not send slack notification' do
          user = create(:user)
          event_type = create(:event_type, slack_webhook: 'http://example.com/webhook')
          attrs = attributes_for(:upcoming_event)
          form = EventForm::CreateEvent.new(Event.new, attrs).as(user)
          allow(Slack::SendNotification).to receive(:call)

          form.save

          expect(Slack::SendNotification).to_not have_received(:call)
        end
      end
    end
  end

  describe 'validations' do
    describe 'datetime' do
      context 'if datetime is present and future' do
        it 'has no errors' do
          travel_to Time.zone.local(2018, 2, 1, 10, 0, 0) do
            attrs = { datetime: '2018-04-04 10:00 AM +0400' }
            form = EventForm::CreateEvent.new(Event.new, attrs)

            form.validate

            expect(form.errors[:datetime]).to be_empty
          end
        end
      end

      context 'if datetime is blank' do
        it 'has errors' do
          travel_to Time.zone.local(2018, 2, 1, 10, 0, 0) do
            attrs = {}
            form = EventForm::CreateEvent.new(Event.new, attrs)

            form.validate

            expect(form.errors[:datetime]).to include "can't be blank"
          end
        end
      end

      context 'if datetime is present and past' do
        it 'has errors' do
          travel_to Time.zone.local(2018, 2, 1, 10, 0, 0) do
            attrs = { datetime: '2017-12-30 8:00 PM +0200' }
            form = EventForm::CreateEvent.new(Event.new, attrs)

            form.validate

            expect(form.errors[:datetime]).to include "can't be in the past"
          end
        end
      end
    end

    it { is_expected.to validate_presence_of(:event_type_id) }
  end
end
