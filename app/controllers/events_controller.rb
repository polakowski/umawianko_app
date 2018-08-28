class EventsController < AuthenticatedController
  def index
    @events = Event.upcoming
  end

  def new
    @event = Event.new
  end

  def create
    @resource = Event.new
    @event = EventForm::CreateEvent.new(@resource, event_params).as(current_user)

    if @event.save
      flash[:success] = 'Event created!'
      redirect_to :events
    else
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params[:event]
  end
end
