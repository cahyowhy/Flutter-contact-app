class UserGroupsController < ApplicationController
  before_action :set_user_group, only: [:destroy]

  # GET /user_groups
  def index
    param_search = {}

    params.each do |key, value|
      restrict_key = key.to_s == "_json" || key.to_s == "controller" || key.to_s == "action" || key.to_s == "username" ||
          key.to_s == "user_group" || key.to_s == "offset" || key.to_s == "limit"

      unless restrict_key
        param_search[key] = value
      end
    end

    @user_groups = UserGroup.where(param_search)

    render json: generate_response(@user_groups, UserGroupSerializer, get_status_code(:ok))
  end

  # POST /user_groups
  def create
    @user_group = UserGroup.new(user_group_params)

    if @user_group.save
      render json: generate_response(@user_group, UserGroupSerializer, get_status_code(:created)),
             status: :created, location: @user_group
    else
      render json: generate_response_custom(@user_group.errors, get_status_code(:unprocessable_entity)), status: :unprocessable_entity
    end
  end

  # DELETE /user_groups/1
  def destroy
    @user_group.destroy

    render json: generate_response_custom({:message => 'delete success'}, get_status_code(:deleted))
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_group
    @user_group = UserGroup.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_group_params
    params.require(:user_group).permit(:group_id, :user_id)
  end
end
