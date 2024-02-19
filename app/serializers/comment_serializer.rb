class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :post_id, :content, :created_at, :user_id, :username

  attribute :username do |object|
    object.user.profile.username
  end
end
