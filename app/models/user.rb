require 'devise/jwt'
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :profile
  has_many :posts
  validates :password, length: {minimum: 7}, on: :create
  has_many :comments
  has_many :likes

  has_many :followers, class_name: 'FollowRequest', foreign_key: 'following_id', dependent: :destroy
  has_many :followings, class_name: 'FollowRequest', foreign_key: 'follower_id', dependent: :destroy

  has_many :accepted_followers, -> { where(follow_requests: { status: FollowRequest.statuses[:accepted] }) }, through: :followers, source: :follower
  has_many :accepted_followings, -> { where(follow_requests: { status: FollowRequest.statuses[:accepted] }) }, through: :followings, source: :following

  # has_many :pending_followers, -> { where(follow_requests: { status: :pending }) }, through: :followers, source: :follower
  # has_many :pending_followings, -> { where(follow_requests: { status: :pending }) }, through: :followings, source: :following

  has_many :requested_followers, -> { where(follow_requests: { status: FollowRequest.statuses[:pending] }) }, through: :followings, source: :follower
  has_many :requested_followings, -> { where(follow_requests: { status: FollowRequest.statuses[:pending] }) }, through: :followers, source: :following
  
  # to send messages
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver-id'  

  def jwt_payload
    super
  end

  def generate_jwt
    JWT.encode(jwt_payload, Rails.application.credentials.secret_key_base)
  end
end
