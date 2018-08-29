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

  def edit
    @resource = Event.find(params[:id])
    @event = EventForm::CreateEvent.new(@resource)
  end

  def update
    @resource = Event.new
    @event = EventForm::CreateEvent.new(@resource, event_params).as(current_user)

    if @event.save
      flash[:success] = 'Successfully updated event!'
      redirect_to @event
    else
      render :edit
    end
  end

  private

  def event_params
    params[:event]
  end
end
