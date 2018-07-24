class ContactsController < ApplicationController
  before_action :set_contact, only: [:update]

  def update
    if @contact.update(contact_params)
      render json: generate_response(@contact, ContactSerializer, get_status_code(:updated))
    else
      render json: generate_response_custom(@contact.errors, get_status_code(:unprocessable_entity)), status: :unprocessable_entity
    end
  end

  private
  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.requre(:contact).permit(:email, :website)
  end
end
