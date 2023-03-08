class ContactEntry < ApplicationRecord
  belongs_to :contacter, class_name: 'User'
  belongs_to :contactee, class_name: 'User'
end
