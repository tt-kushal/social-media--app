class Post < ApplicationRecord
  
    belongs_to :profile
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many_attached :media

    validates :user, :profile, :media, presence: true

    after_create :increment_profile_post_count
    after_destroy :decrement_profile_post_count

    private
  
    def increment_profile_post_count
      profile.increment!(:post_count) if profile.present?
    end

    def decrement_profile_post_count
      profile.decrement!(:post_count) if profile.present?
    end
end
