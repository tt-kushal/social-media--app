class Profile < ApplicationRecord
    belongs_to :user
    has_one_attached :profile_image
    has_many :posts, dependent: :destroy

    validates :username, :phone_number, :date_of_birth, presence: true
    enum privacy_status: { public_profile: 0, private_profile: 1 }
end
