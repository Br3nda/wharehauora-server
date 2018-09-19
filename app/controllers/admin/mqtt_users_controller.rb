# frozen_string_literal: true

class Admin::MqttUsersController < Admin::AdminController
  def index
    authorize :mqtt_user
    @homes = policy_scope Home.all.includes(:mqtt_user)
  end

  def create
    authorize :mqtt_user
    @home = policy_scope(Home).find(params[:home_id])
    @home.provision_mqtt!
    redirect_to admin_mqtt_users_path
  end
end
