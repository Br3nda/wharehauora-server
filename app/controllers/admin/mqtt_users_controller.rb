class Admin::MqttUsersController < ApplicationController
  def index
    authorize :mqtt_user
    @users = policy_scope User.includes(:owned_homes, :mqtt_user).all
  end

  def create
    authorize :mqtt_user
    @user = User.find(params[:user_id])
    @user.provision_mqtt!
    redirect_to admin_mqtt_users_path
  end

  def sync
    authorize :mqtt_user
    Mqtt.sync_mqtt_users
    redirect_to admin_mqtt_users_path
  end
end
