class HomeController < StaticController
  layout 'guest'

  def index
    return redirect_to '/events' if user_signed_in?
  end
end
