class StaticAuthenticatedController < StaticController
  before_action :authenticate_user!
end
