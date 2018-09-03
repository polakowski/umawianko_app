describe 'join event', type: :feature do
  scenario 'assigns user to an event' do
    event = create(:upcoming_event)
    current_user = create(:user)
    signed_in_as current_user

    visit "/events/#{event.id}/event_users/new"

    fill_in 'No. of friends', with: '2'

    expect { click_button 'Sign me up' }
      .to change { event.event_users.count }.by(1)
      .and change { event.participants_count }.by(3)
  end
end
