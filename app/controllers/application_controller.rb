class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  rescue_from Umawianko::UserNotSignedIn do
    redirect_to sign_in_path
  end

  rescue_from Umawianko::OAuthError do
    redirect_to sign_in_path
  end

  def authenticate_user!
    return if user_signed_in?
    raise Umawianko::UserNotSignedIn
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    return true if current_user
  end
end
