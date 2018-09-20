describe EventForm::UpdateEvent, type: :form do
  describe 'validations' do
    context 'presence validations' do
      let(:subject) { EventForm::UpdateEvent.new(create(:upcoming_event)) }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:place) }
    end

    describe 'resource datetime validation' do
      context 'when resource event is in past' do
        it 'adds error to base' do
          event = create(:past_event)
          form = EventForm::UpdateEvent.new(event, {})

          form.validate

          expect(form.errors[:base]).to include 'This event took place in the past. '\
            'You cannot update any information connected with the event.'
        end
      end

      context 'when resource event is in future' do
        it 'adds no error' do
          event = create(:upcoming_event)
          form = EventForm::UpdateEvent.new(event, {})

          form.validate

          expect(form.errors[:base]).to be_empty
        end
      end
    end
  end
end
