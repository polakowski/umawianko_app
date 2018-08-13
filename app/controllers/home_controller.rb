class HomeController < AuthenticatedController
  def index
    redirect_to '/events'
  end
end
