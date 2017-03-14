# frozen_string_literal: true
class SensorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sensor, only: [:show, :edit, :destroy, :update]

  def index
    @home = policy_scope(Home).find(params[:home_id])
    authorize @home
    @sensors = policy_scope(Sensor).joins_home.where('home_id =?', @home.id)
  end

  private

  def set_sensor
    @sensor = policy_scope(Sensor).find(params[:id])
    authorize @sensor
  end
end
