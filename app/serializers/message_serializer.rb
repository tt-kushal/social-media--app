class MessageSerializer
  include FastJsonapi::ObjectSerializer
  attributes :username, :body

  attribute :username do |object|
    object.sender.profile.username
  end

end
