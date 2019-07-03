describe EventUser do
  describe '#destroy' do
    it 'calls #sign_off!' do
      event_user = create(:event_user)
      allow(event_user).to receive(:sign_off!)

      event_user.destroy

      expect(event_user).to have_received(:sign_off!)
    end

    context 'is already deleted' do
      it 'does not call #sign_off!' do
        event_user = create(:event_user, deleted_at: 2.hours.ago)
        allow(event_user).to receive(:sign_off!)

        event_user.destroy

        expect(event_user).not_to have_received(:sign_off!)
      end
    end
  end

  describe '#sign_off!' do
    it 'updates sign_off_count' do
      event_user = create(:event_user, sign_off_count: 4)

      expect {
        event_user.sign_off!
      }.to change {
        event_user.sign_off_count
      }.from(4).to(5)
    end
  end
end
