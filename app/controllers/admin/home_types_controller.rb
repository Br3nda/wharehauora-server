class Admin::HomeTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_home_type, only: [:show, :edit, :update, :destroy]

  def index
    authorize :home_type
    @home_types = policy_scope(HomeType)
  end

  def edit; end

  def update
    @home_type.update!(home_type_params)
    redirect_to admin_home_types_path
  end

  def new
    authorize :home_type
    @home_type = HomeType.new
  end

  def create
    authorize :home_type
    HomeType.create(home_type_params)
    redirect_to admin_home_types_path
  end

  def destroy
    @home_type.destroy
    redirect_to admin_home_types_path
  end

  private

  def set_home_type
    @home_type = HomeType.find(params[:id])
    authorize @home_type
  end

  def home_type_params
    params[:home_type].permit(:name)
  end
end
