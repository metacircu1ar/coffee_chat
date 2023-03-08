Rails.application.routes.draw do
  root 'root#index'
  
  # Authorization routes
  ## Check if the user is authorized given user_id and cookie
  post '/auth/authorized/:user_id', to: 'users#authorized'

  ## Log in the user given email and password 
  ## On success returns user_id and cookie
  post '/auth/login', to: 'users#login'

  ## Log out the user given user_id and cookie
  post '/auth/logout/:user_id', to: 'users#logout'
  
  ## Register a new user given email, name and a password.
  ## On success returns user_id  
  post '/auth/register', to: 'users#register'

  # Contact routes
  ## Get all the contacts of the user, returns contact_ids
  get '/users/:user_id/contacts', to: 'contacts#index'

  ## Add a new contact to the user's contact list
  post '/users/:user_id/contacts/:contact_id', to: 'contacts#create'

  # Chat routes
  ## Get all the chats that the user is a member of
  get '/users/:user_id/chats', to: 'chats#index'
  get '/users/:user_id/chats/time/:created_at_or_after', to: 'chats#index'

  ## Create a new chat owned by the user
  post '/users/:user_id/chats', to: 'chats#create'

  ## Show the specific chat that the user is a member of
  get '/users/:user_id/chats/:chat_id', to: 'chats#show'

  ## Get unread message count of a chat
  get '/users/:user_id/chats/:chat_id/unread_count', to: 'unread_counts#show'

  ## Get the list of all members of a chat
  get '/users/:user_id/chats/:chat_id/members', to: 'memberships#index'

  ## Add a new member to the chat owned by user
  post '/users/:user_id/chats/:chat_id/members/:member_id', to: 'memberships#create'

  # Messages routes
  ## Get all the messages in the chat
  get '/users/:user_id/chats/:chat_id/messages', to: 'messages#index'
  get '/users/:user_id/chats/:chat_id/messages/time/:created_at_or_after', to: 'messages#index'

  ## Add a new message to the chat
  post '/users/:user_id/chats/:chat_id/messages', to: 'messages#create'

  ## Show a specific message
  get '/users/:user_id/chats/:chat_id/messages/:message_id', to: 'messages#show'
end
