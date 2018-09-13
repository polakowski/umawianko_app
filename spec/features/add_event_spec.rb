describe 'add event', type: :feature do
  context 'with auto-join not checked' do
    scenario 'creates an event and assigns creator' do
      travel_to Time.zone.local(2018, 2, 1, 10, 0, 0) do
        current_user = create(:user)
        create(:event_type, name: 'Foo-bar')
        signed_in_as current_user
        visit '/events/new'

        within '#new_event' do
          fill_in 'Name', with: 'Event'
          fill_in 'Place', with: 'Las Vegas, NV'
          fill_in 'Event time', with: '2018-03-06 02:00 PM'
          select 'Foo-bar', from: 'Event type'

          expect { click_button 'Submit' }
            .to change { Event.count }.by(1)
            .and not_change { EventUser.count }
        end
      end
    end
  end

  context 'with auto-join checked' do
    scenario 'creates an event and assigns creator' do
      travel_to Time.zone.local(2018, 1, 1, 10, 0, 0) do
        current_user = create(:user)
        create(:event_type, name: 'Foo-bar')
        signed_in_as current_user
        visit '/events/new'

        within '#new_event' do
          fill_in 'Name', with: 'Event'
          fill_in 'Place', with: 'Las Vegas, NV'
          fill_in 'Event time', with: '2018-03-01 04:00 PM'
          select 'Foo-bar', from: 'Event type'
          check 'Auto-join'

          expect { click_button 'Submit' }
            .to change { Event.count }.by(1)
            .and change { EventUser.count }.by(1)
        end
      end
    end
  end

  context 'if event type has slack webhook' do
    scenario 'it sends slack notification' do
      travel_to Time.zone.local(2018, 2, 1, 10, 0, 0) do
        current_user = create(:user)
        create(:event_type, name: 'Foo-bar', slack_webhook: 'https://foo.com/webhook')
        signed_in_as current_user
        visit '/events/new'

        within '#new_event' do
          fill_in 'Name', with: 'The Event'
          fill_in 'Place', with: 'Salt Lake City'
          fill_in 'Event time', with: '2019-01-01 09:00 AM'
          select 'Foo-bar', from: 'Event type'

          allow(Slack::SendNotification).to receive(:call)

          click_button 'Submit'

          expect(Slack::SendNotification).to have_received(:call).once.with(
            'https://foo.com/webhook',
            '#aaa'
          )
        end
      end
    end
  end
end
