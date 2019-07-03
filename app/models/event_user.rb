class EventUser < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :event

  def destroy
    sign_off! unless deleted?
    super
  end

  def sign_off!
    update sign_off_count: sign_off_count + 1
  end
end
