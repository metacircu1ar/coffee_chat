class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :text, presence: true, length: { minimum: 1 }
  before_validation :strip_text

  def strip_text
    self.text.strip!
  end
end
