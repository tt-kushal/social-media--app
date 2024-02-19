FactoryBot.define do
    factory :profile do
        username { Faker::Internet.unique.username }
        full_name { Faker::Name.name }
        phone_number { Faker::PhoneNumber.phone_number }
        date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
        post_count { Faker::Number.between(from: 0, to: 100) }
        bio { Faker::Lorem.paragraph }
        age { Faker::Number.between(from: 18, to: 65) }
        gender { Faker::Gender.binary_type }
        country { Faker::Address.country }
        state { Faker::Address.state }
        address { Faker::Address.full_address }
        user
        # after(:build) do |profile|
        #     file_path = Rails.root.join('spec', 'fixtures', 'icon.jpg')
        
        #     profile.profile_image.attach(io: File.open(file_path),
        #     filename: 'icon.jpg', 
        #     content_type: 'image/jpeg') 
        # end
    end
end