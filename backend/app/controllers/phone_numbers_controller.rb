class PhoneNumbersController < ApplicationController
  before_action :set_phone_number, only: [:show, :update, :destroy]

  # POST /phone_numbers
  def create
    @phone_number = PhoneNumber.new(attributes_params)

    if @phone_number.save
      render json: generate_response(@phone_number, PhoneNumberSerializer, get_status_code(:created)),
             status: :created, location: @phone_number
    else
      render json: generate_response_custom(@phone_number.errors, get_status_code(:unprocessable_entity)), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /phone_numbers/1
  def update
    if @phone_number.update(attributes_params)
      render json: generate_response(@phone_number, PhoneNumberSerializer, get_status_code(:updated))
    else
      render json: generate_response_custom(@phone_number.errors, get_status_code(:unprocessable_entity)), status: :unprocessable_entity
    end
  end

  # DELETE /phone_numbers/1
  def destroy
    @phone_number.destroy

    render json: generate_response_custom({:message => 'delete success'}, get_status_code(:deleted))
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_phone_number
    @phone_number = PhoneNumber.find(params[:id])
  end

  # allow sent request body without parent attributes
  def attributes_params
    {:contact_id => params[:contact_id], :phone_number => params[:phone_number]}
  end
end
