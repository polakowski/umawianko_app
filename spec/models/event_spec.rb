describe Event do
  describe 'destroying' do
    context 'when no users joined the event' do
      it 'can be destroyed' do
        event = create(:event)

        expect {
          event.destroy
        }.to change {
          Event.count
        }.by(-1)
      end
    end

    context 'when at least one user joined the event' do
      it 'can be destroyed' do
        event = create(:event)
        create(:event_user, event: event)

        expect {
          event.destroy
        }.to not_change {
          User.count
        }.and raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end
  end
end
