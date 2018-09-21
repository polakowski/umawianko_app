class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery with: :exception

  helper_method :current_user

  def authenticate_user!
    return if user_signed_in?
    raise Umawianko::UserNotSignedIn
  end

  def current_user
    return User.first
    @current_user ||= User.find_by(uid: session[:user_uid])
  end

  def user_signed_in?
    return true if current_user
  end
end
