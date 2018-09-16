# frozen_string_literal: true

class MqttUserController < ApplicationController
  before_action :authenticate_user!

  def index
    @home = policy_scope(Home).find(params[:home_id])
    authorize @home
    @gateway = Gateway.find_by(mac_address: @home.gateway_mac_address) if @home.gateway_mac_address.present?
  end
end
