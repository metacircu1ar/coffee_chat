require 'bcrypt'
require 'securerandom'

class User < ApplicationRecord
  include BCrypt
  attr_accessor :user_password
  
  before_save { self.email = email.downcase }

  has_many :contact_entries, foreign_key: :contacter_id
  has_many :contacts, through: :contact_entries, source: :contactee

  has_many :unread_counts, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :chats, through: :memberships
  has_many :owned_chats, class_name: 'Chat', foreign_key: 'user_id', dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  validates :user_password, format: { without: /\s/, message: "must contain no spaces" }
  validates :user_password, presence: true, length: { minimum: 6 }

  validates :name, format: { without: /\s/, message: "must contain no spaces" }
  validates :name, presence: true, length: { minimum: 1 }

  def password
    @password ||= Password.new(password_digest)
  end
  
  def password=(raw_password)
    @password = Password.create(raw_password)
    self.user_password = raw_password
    self.password_digest = @password
  end

  def cookie
    @cookie ||= Password.new(cookie_digest)
  end

  def cookie=(new_cookie)
    @cookie = Password.create(new_cookie)
    self.cookie_digest = @cookie
  end

  def generate_and_save_new_cookie
    new_cookie = "#{SecureRandom.uuid}-#{SecureRandom.uuid}"
    update_attribute(:cookie, new_cookie)
    new_cookie
  end
end

