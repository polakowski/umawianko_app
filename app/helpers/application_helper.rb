module ApplicationHelper
  def format_user_or_current_user(user)
    return user.to_s if user != current_user
    return "#{user.to_s} (you)"
  end
end
