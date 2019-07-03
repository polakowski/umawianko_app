describe Events::LeaveEvent do
  describe '.call' do
    context 'if user_event is already deleted' do
      it 'does not change deleted_at' do
        event_user = create(:event_user)

        expect {
          Events::LeaveEvent.call(event_user)
        }.to_not change {
          event_user.deleted?
        }
      end
    end

    context 'if event has passed' do
      it 'does not change deleted_at' do
        event = create(:past_event)
        event_user = create(:event_user, event: event)

        Events::LeaveEvent.call(event_user)

        expect {
          Events::LeaveEvent.call(event_user)
        }.to_not change {
          event_user.deleted?
        }
      end
    end

    context 'if event is in future' do
      it 'deletes record' do
        event = create(:upcoming_event)
        event_user = create(:event_user, event: event)

        expect {
          Events::LeaveEvent.call(event_user)
        }.to change {
          event_user.reload.deleted?
        }.from(false).to(true)
      end
    end
  end
end
