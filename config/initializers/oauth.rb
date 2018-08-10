Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 
    ENV.fetch('OAUTH_CLIENT_ID'),
    ENV.fetch('OAUTH_SECRET'),
    { scope: 'email, profile' }
end
