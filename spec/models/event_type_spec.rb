describe EventType do
  describe 'destroying' do
    context 'when events are not assigned' do
      it 'can be destroyed' do
        event_type = create(:event_type)

        expect {
          event_type.destroy
        }.to change {
          EventType.count
        }.by(-1)
      end
    end

    context 'when events are assigned' do
      it 'cannot be destroyed' do
        event_type = create(:event_type)
        create(:event, event_type: event_type)

        expect {
          event_type.destroy
        }.to not_change {
          User.count
        }.and raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end
  end
end
