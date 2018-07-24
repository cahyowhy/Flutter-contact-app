class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]

  # GET /users
  def index
    if params[:limit].present? && params[:limit].present?
      if params[:id].present?
        @user = User.find(params[:id])
        render json: generate_response(@user, UserSerializer, get_status_code(:ok), {show_contact: true})
      elsif params[:group_id].present?
        @users = User.joins(:user_groups).offset(params[:offset]).limit(params[:limit]).where('user_groups.group_id' => params[:group_id]).uniq
        render json: generate_response(@users, UserSerializer, get_status_code(:ok))
      elsif params[:user_name].present?
        @users = User.start_with('name', params[:user_name]).offset(params[:offset]).limit(params[:limit])
        render json: generate_response(@users, UserSerializer, get_status_code(:ok))
      else
        @users = User.offset(params[:offset]).limit(params[:limit])
        render json: generate_response(@users, UserSerializer, get_status_code(:ok))
      end
    else
      render json: generate_response_custom({:message => 'require offset limit!'}, get_status_code(:bad_request)), status: :bad_request
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      @user_profile = User.find(@user.id)
      render json: generate_response(@user_profile, UserSerializer, get_status_code(:created), {show_contact: true}),
             status: :created
    else
      render json: generate_response_custom(@user.errors, status: :unprocessable_entity), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      params[:contacts].each do |item|
        if item[:id] == 0
          Contact.create(email: item[:email], website: item[:website])
        else
          contact = Contact.find(item[:id])
          contact.update(email: item[:email], website: item[:website])
        end
      end

      render json: generate_response(@user, UserSerializer, get_status_code(:updated))
    else
      render json: generate_response_custom(@user.errors, get_status_code(:unprocessable_entity)), status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy

    render json: generate_response_custom({:message => 'Data berhasil dihapus'}, get_status_code(:deleted))
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :surname, :address, :dob, :about, :image_profile,
                                 :contacts_attributes => [:email, :website])
  end
end