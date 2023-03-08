module ContactsHelper
  def add_contact(user, contact_id)
    contact = User.find_by(id: contact_id)
    return false if !contact
    user.contacts << contact if !user.contacts.include?(contact)
    true
  end
end