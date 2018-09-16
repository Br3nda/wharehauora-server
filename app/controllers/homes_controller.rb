# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_home, only: %i[show edit destroy update]
  respond_to :html

  def index
    authorize :home
    @homes = policy_scope(Home)
             .includes(:home_type, :owner)
             .order(:name)
             .paginate(page: params[:page])
    respond_with(@homes)
  end

  def show
    parse_dates
    @keys = %w[temperature humidity]
    respond_with(@home)
  end

  def new
    authorize :home
    @home = Home.new
    respond_with(@home)
  end

  def create
    @home = Home.new(home_params)
    authorize @home
    invite_new_owner
    @home.save
    respond_with(@home)
  end

  def edit
    @home_types = HomeType.all
    respond_with(@home)
  end

  def update
    if @home.update(home_params)
      @home.provision_mqtt! if @home.gateway_mac_address.present?
    end
    respond_with(@home)
  end

  def destroy
    @home.destroy
    respond_with(@home)
  end

  private

  def invite_new_owner
    if current_user.janitor?
      owner = User.find_by(owner_params)
      @home.owner = owner || User.invite!(owner_params)
    else
      @home.owner = current_user
    end
  end

  def parse_dates
    @day = params[:day]
    @day = Time.zone.today if @day.blank?
  end

  def home_params
    params.require(:home).permit(:name, :is_public, :home_type_id, :gateway_mac_address)
  end

  def owner_params
    params.require('owner').permit('email')
  end

  def set_home
    @home = policy_scope(Home).find(params[:id])
    authorize @home
  end
end
