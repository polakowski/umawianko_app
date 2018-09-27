FactoryBot.define do
  factory :event do
    name { 'Test Event' }
    place { 'Salt Lake City, UT' }
    datetime { Time.current }
    creator { create(:user) }

    factory :upcoming_event do
      datetime { 3.months.from_now }
    end

    factory :past_event do
      datetime { 2.weeks.ago }
    end

    trait :with_type do
      event_type
    end
  end
end
