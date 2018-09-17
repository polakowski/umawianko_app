describe Events::JoinEvent do
  describe '.call' do
    context 'when event is upcoming' do
      context 'when user have not joined the event' do
        it 'creates user_event' do
          event = create(:upcoming_event)
          user = create(:user)

          expect {
            Events::JoinEvent.call(event, user, 7)
          }.to change {
            EventUser.count
          }.by(1)

          expect(EventUser.last).to have_attributes(
            user_id: user.id,
            event_id: event.id,
            friends_count: 7
          )
        end
      end

      context 'when user have joined the event' do
        it 'updates the user_event' do
          event = create(:upcoming_event)
          user = create(:user)
          event_user = create(:event_user, event: event, user: user, friends_count: 1)

          expect {
            Events::JoinEvent.call(event, user, 4)
          }.to not_change {
            EventUser.count
          }.and change {
            EventUser.find(event_user.id).friends_count
          }.from(1).to(4)
        end
      end
    end

    context 'when event is past' do
      it 'raises error' do
        event = create(:past_event)
        user = create(:user)
        create(:event_user, event: event, user: user)

        expect {
          Events::JoinEvent.call(event, user, 3)
        }.to not_change {
          EventUser.count
        }.and raise_error(Umawianko::RuntimeError)
      end
    end
  end
end
