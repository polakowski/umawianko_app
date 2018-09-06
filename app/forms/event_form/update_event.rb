module EventForm
  class UpdateEvent < EventForm::Base
    param_key 'event'

    private

    def persist
      update_event
    end

    def update_event
      resource.assign_attributes attributes
      resource.save
    end
  end
end
