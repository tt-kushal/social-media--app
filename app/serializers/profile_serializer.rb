class ProfileSerializer
  include FastJsonapi::ObjectSerializer
  attributes :username, :full_name, :phone_number, :date_of_birth, :post_count, :bio, :age, 
                        :gender, :country, :state, :address, :user_id, :privacy_status, :followers, :followings

  attribute :post_count do |object| 
    object.posts.count
  end

  attributes :profile_image do |object|
    if object.profile_image.present?
      host = Rails.env.development? ? 'http://localhost:3000' : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(object.profile_image,only_path: true)
    end
  end

  attributes :followers do |object|
    object.user.accepted_followers.count
  end

  attributes :followings do |object|
    object.user.accepted_followings.count
  end

end 
