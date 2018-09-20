FactoryBot.define do
  factory :event_user do
    event
    user
    friends_count { 0 }
  end
end
