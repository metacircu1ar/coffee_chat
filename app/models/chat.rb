class Chat < ApplicationRecord
  belongs_to :user
  
  has_many :memberships, dependent: :destroy
  has_many :unread_counts, dependent: :destroy
  has_many :users, through: :memberships

  has_many :messages

  validates :topic, presence: true, length: { minimum: 1 }
  before_validation :strip_topic

  def strip_topic
    self.topic.strip!
  end
end
