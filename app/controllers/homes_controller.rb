# frozen_string_literal: true
class HomesController < WebController
  before_action :authenticate_user!

  def index
    @homes = policy_scope(Home)
  end

  def show
    @home = Home.find(params[:id])
    authorize @home
    @rooms = @home.rooms

    @unassigned = Sensor.where("room_id IS NULL", home_id: @home.id)
  end

  def new
    authorize :home
    @home = Home.new
  end

  def create
    @home = Home.new(home_params)
    authorize @home
    @home.save!
    redirect_to @home
  end

  def edit
    @home = Home.find(params[:id])
    authorize @home
  rescue ActiveRecord::RecordNotFound
    skip_authorization
    redirect_to homes_path
  end

  def update
    @home = Home.find(params[:id])
    authorize @home
    @home.update(home_params)
    @home.save!
    redirect_to @home
  end

  def destroy
    @home = Home.find(params[:id])
    authorize @home
    @home.destroy!
    redirect_to homes_path
  rescue ActiveRecord::RecordNotFound
    skip_authorization
    redirect_to homes_path
  end

  private

  def home_params
    params[:home].permit(permitted_home_params).merge(
      owner_id: current_user.id
    )
  end

  def permitted_home_params
    %i(name)
  end
end
