# frozen_string_literal: true

class MqttUserController < ApplicationController
  before_action :authenticate_user!

  def index
    @home = policy_scope(Home).find(params[:home_id])
    authorize(@home)
  end
end
