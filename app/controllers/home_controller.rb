class HomeController < StaticController
  def index
    redirect_to '/events'
  end
end
