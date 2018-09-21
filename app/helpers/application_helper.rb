module ApplicationHelper
  include Pagy::Frontend

  def format_user_or_current_user(user)
    string = user.to_s
    string += content_tag(:span, ' (you)', class: 'text-muted') if user == current_user
    string
  end
end
