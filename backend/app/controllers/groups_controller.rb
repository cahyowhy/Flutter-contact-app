class GroupsController < ApplicationController
  before_action :set_group, only: [:update, :destroy]

  # GET /groups
  def index
    @groups = Group.all

    render json: generate_response(@groups, GroupSerializer, get_status_code(:ok))
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      render json: generate_response(@group, GroupSerializer, get_status_code(:ok)),
             status: :created, location: @group
    else
      render json: generate_response_custom(@group.errors, get_status_code(:unprocessable_entity)), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: generate_response(@group, GroupSerializer, get_status_code(:updated))
    else
      render json: generate_response_custom(@group.errors, get_status_code(:unprocessable_entity)), status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy

    render json: generate_response_custom({:message => 'delete success'}, get_status_code(:deleted))
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def group_params
    params.require(:group).permit(:name)
  end
end
