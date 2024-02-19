class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :profile_id, :user_id, :media, :caption, :likes_count, :comments_count 

  attribute :media do |post|
    if post.media.attached?
      host = Rails.env.development? ? 'http://localhost:3000' : ENV["BASE_URL"]
      media_urls = post.media.map do |attachment|
        host + Rails.application.routes.url_helpers.rails_blob_url(attachment, only_path: true)
      end
      media_urls
    end
  end

  attribute :comments_count do |object|
    object.comments.count
  end

  attribute :likes_count do |object|
    object.likes.count
  end
end