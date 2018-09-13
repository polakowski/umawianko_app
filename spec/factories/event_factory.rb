FactoryBot.define do
  factory :event do
    name { 'Test Event' }
    place { 'Salt Lake City, UT' }
    datetime { Time.current }
    creator { create(:user) }
    event_type { create(:event_type) }

    factory :upcoming_event do
      datetime { 3.months.from_now }
    end
  end
end
