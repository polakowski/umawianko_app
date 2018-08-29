class EventsController < AuthenticatedController
  def index
    @events = Event.upcoming
  end

  def new
    @resource = Event.new
    @event = EventForm::CreateEvent.new(@resource)
  end

  def create
    @resource = Event.new
    @event = EventForm::CreateEvent.new(@resource, event_params).as(current_user)

    if @event.save
      flash[:success] = 'Event created!'
      redirect_to @event
    else
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @event_user = @event.event_users.find_by(user: current_user)
  end

  private

  def event_params
    params[:event]
  end
end
