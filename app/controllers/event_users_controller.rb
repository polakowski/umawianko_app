class EventUsersController < AuthenticatedController
  def new
    find_event
    @resource = EventUser.new
    @event_user = EventUserForm::CreateEventUser.new(@resource)
  end

  def create
    find_event
    @resource = EventUser.new
    @event_user = EventUserForm::CreateEventUser.new(@resource, event_user_params).as(current_user)

    if @event_user.save
      flash[:success] = 'Successfully joined event!'
      redirect_to @event
    else
      render :new
    end
  end

  def edit
    find_event
    @resource = EventUser.find(params[:id])
    @event_user = EventUserForm::CreateEventUser.new(@resource)
  end

  def update
    find_event
    @resource = EventUser.find(params[:id])
    @event_user = EventUserForm::CreateEventUser.new(@resource, event_user_params).as(current_user)

    if @event_user.save
      flash[:success] = 'Successfully updated your application!'
      redirect_to @event
    else
      render :edit
    end
  end

  private

  def event_user_params
    params[:event_user].merge(event_id: @event.id)
  end

  def find_event
    @event = Event.find(params[:event_id])
  end
end
