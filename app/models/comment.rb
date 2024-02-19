class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :user
  after_create :increment_comment_count
  after_destroy :decrement_comment_count
  validates :content, presence: true

  private

  def increment_comment_count
    post.increment!(:comments_count) if post.present?
  end

  def decrement_comment_count
    post.decrement!(:comments_count) if post.present?
  end
end
