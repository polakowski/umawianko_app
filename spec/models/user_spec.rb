describe User do
  describe 'destroying' do
    context 'when no events created nor joined' do
      it 'can be destroyed' do
        user = create(:user)

        expect {
          user.destroy
        }.to change {
          User.count
        }.by(-1)
      end
    end

    context 'when at least one event created' do
      it 'cannot be destroyed' do
        user = create(:user)
        create(:event, creator: user)

        expect {
          user.destroy
        }.to not_change {
          User.count
        }.and raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end

    context 'when at least one event joined' do
      it 'cannot be destroyed' do
        user = create(:user)
        event = create(:event)
        create(:event_user, event: event, user: user)

        expect {
          user.destroy
        }.to not_change {
          User.count
        }.and raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end
  end
end
