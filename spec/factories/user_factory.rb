FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    uid { SecureRandom.uuid }
  end
end
