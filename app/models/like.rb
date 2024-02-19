class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates  :post, presence: true
  validates_uniqueness_of :user_id, scope: :post_id

  after_create :increment_likes_count
  after_destroy :decrement_likes_count

  private

  def increment_likes_count
    post.increment!(:likes_count) if post.present?
  end

  def decrement_likes_count
    post.decrement!(:likes_count) if post.present?
  end
end
