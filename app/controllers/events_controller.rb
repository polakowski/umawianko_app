class EventsController < StaticAuthenticatedController
  def index
    @events = filter_by_event_type(events_scope)
  end

  def new
    @resource = Event.new
    @event = EventForm::CreateEvent.new(@resource)
    @event_types = EventType.all
  end

  def create
    @resource = Event.new
    @event = EventForm::CreateEvent.new(@resource, event_params).as(current_user)
    @event_types = EventType.all

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
    @event = EventForm::UpdateEvent.new(@resource)
  end

  def update
    @resource = Event.find(params[:id])
    @event = EventForm::UpdateEvent.new(@resource, event_params).as(current_user)

    if @event.save
      flash[:success] = 'Successfully updated event!'
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])

    Events::DeleteEvent.call(@event)

    if @event.deleted?
      flash[:success] = 'Event deleted successfully.'
      redirect_to events_path
    else
      flash[:alert] = @event.errors[:base] || 'Could not delete event.'
      redirect_to @event
    end
  end

  private

  def event_params
    params[:event]
  end

  def filter_by_event_type(scope)
    return scope if event_type_id.blank?
    @event_type = EventType.find(event_type_id)
    scope.of_event_type_id(event_type_id)
  end

  def event_type_id
    @event_type_id ||= params[:event_type_id]
  end

  def events_scope
    Event.upcoming.newest_first.includes(:event_type)
  end
end
