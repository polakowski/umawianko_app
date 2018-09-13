module EventForm
  class Base < ApplicationForm
    attribute :name, String
    attribute :description, String
    attribute :place, String

    validates :name, :place, presence: true
  end
end
