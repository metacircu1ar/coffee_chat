class ContactsController < ApplicationController
  skip_before_action :verify_authenticity_token
  around_action :authorize, only: [:index, :create]
  include ContactsHelper
  
  def index
    render json: current_user.contacts.map { |contact| 
      { 
        id: contact.id, 
        name: contact.name 
      }
    }
  end

  def create
    contact_id = create_params[:contact_id]
    
    if add_contact(current_user, contact_id)
      render json: {
        status: "Success",
        contact_id: contact_id
      }
    else
      render json: {
        status: "Error"
      }, status: 401
    end
  end

  def create_params
    params.permit(:contact_id)
  end
end
