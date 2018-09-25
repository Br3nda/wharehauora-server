# frozen_string_literal: true

class Admin::HomeTypesController < Admin::AdminController
  before_action :set_home_type, only: %i[show edit update destroy]
  respond_to :html

  def index
    authorize :home_type
    @home_types = policy_scope HomeType.all.order(:name)
  end

  def edit; end

  def update
    @home_type.update(home_type_params)
    respond_with(:admin, @home_type, location: admin_home_types_path)
  end

  def new
    authorize :home_type
    @home_type = HomeType.new
  end

  def create
    authorize :home_type
    @home_type = HomeType.create(home_type_params)
    respond_with(:admin, @home_type, location: admin_home_types_path)
  end

  def destroy
    ActiveRecord::Base.transaction do
      Home.where(
        home_type_id: @home_type.id
      ).update_all(home_type_id: nil)
      @home_type.destroy
    end
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
