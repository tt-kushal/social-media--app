FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        password { Faker::Internet.password(min_length: 7) }
    end
  end