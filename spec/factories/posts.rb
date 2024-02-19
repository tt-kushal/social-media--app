FactoryBot.define do
    factory :post do
      caption { Faker::Lorem.sentence }
      media_url { Faker::Internet.url }
      likes_count { Faker::Number.between(from: 0, to: 100) }
      comments_count { Faker::Number.between(from: 0, to: 50) }
      user
      profile
      after(:build) do |post|
            file_path = Rails.root.join('spec', 'fixtures', 'icon.jpg')
        
            post.media.attach(io: File.open(file_path),
            filename: 'icon.jpg', 
            content_type: 'image/jpeg') 
      end
    end
end


  