module EventUsersHelper
  def event_user_submit_text(event_user)
    event_user.persisted? ? 'Save changes' : 'Sign me up'
  end
end
