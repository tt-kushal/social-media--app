class FollowRequest < ApplicationRecord
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :following, class_name: 'User', foreign_key: 'following_id'

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  validates :follower, uniqueness: { scope: :following, message: "has already sent a follow request to this user" }

  def accept!
    update(status: :accepted)
  end

  def reject!
    update(status: :rejected)
  end
end
