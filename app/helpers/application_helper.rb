module ApplicationHelper
  include Pagy::Frontend

  def format_user_or_current_user(user)
    user != current_user ? user.to_s : "#{user} (you)"
  end
end
