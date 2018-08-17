module EventForm
  class Base < BaseForm
    attribute :name, String
    attribute :description, String
    attribute :place, String
    attribute :datetime, DateTime

    validates :name, :place, :datetime, presence: true
  end
end
