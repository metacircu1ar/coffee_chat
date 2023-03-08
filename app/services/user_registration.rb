class UserRegistration
  include Monadic::Transaction
  include ContactsHelper

  def register_user(params)
    user = User.new(params)
    result = run_transaction_block do
      Abort[user.errors.full_messages] if !user.save
      Abort["Failed to add contact"] if !add_contact(user, user.id)
      Ok[user_id: user.id]
    end
  end
end