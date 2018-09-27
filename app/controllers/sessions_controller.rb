class SessionsController < StaticController
  SESSION_KEY = :user_uid

  before_action :authenticate_user!, except: %i[new create]

  def new
    redirect_to '/auth/google_oauth2'
  end

  def create
    @auth = request.env['omniauth.auth']

    if valid_email?
      user = find_or_create_user
      update_and_sign_in(user)
      redirect_to root_url, notice: 'Signed in!'
    else
      redirect_to root_path, error: 'Your domain is not allowed.'
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'Signed out!'
  end

  def failure
    redirect_to root_url, alert: "Authentication error: #{params[:message].humanize}"
  end

  private

  attr_reader :auth

  def find_or_create_user
    User.find_by(uid: @auth['uid'].to_s) || User.create_with_omniauth(@auth)
  end

  def update_and_sign_in(user)
    user.update(image: auth['info']['image']) if user.image.blank?
    reset_session

    user.uid.tap do |value|
      session[SESSION_KEY] = value
      cookies.signed[SESSION_KEY] = value
    end
  end

  def valid_email?
    domain = auth_info['email'].match(/\@.+\z/).to_s[1..-1]
    allowed_domains.include?(domain)
  end

  def auth_info
    @auth['info'].presence || raise(Umawianko::OAuthError, 'Incorrect login data')
  end

  def allowed_domains
    ENV.fetch('OAUTH_ALLOWED_DOMAINS').split(',')
  end
end
