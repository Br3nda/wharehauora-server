# frozen_string_literal: true
class HomesController < WebController
  before_action :authenticate_user!

  def index
    @homes = policy_scope(Home)
  end

  def show
    @home = Home.find(params[:id])
    authorize @home
  end

  def new
    authorize :home
    @home = Home.new
  end

  def create
    @home = Home.new(home_params)
    authorize @home
    @home.save!
    redirect_to web_homes_path
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
