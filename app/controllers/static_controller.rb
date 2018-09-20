class StaticController < ApplicationController
  rescue_from Umawianko::UserNotSignedIn do
    redirect_to sign_in_path
  end

  rescue_from Umawianko::OAuthError do
    redirect_to sign_in_path
  end
end
