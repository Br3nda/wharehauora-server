class Admin::MqttUsersController < ApplicationController
  def index
    authorize :mqtt_user
    @users = User.all
  end

  def create
    authorize :mqtt_user
    @user = User.find(params[:user_id])
    @user.provision_mqtt
    redirect_to admin_mqtt_users_path
  end
end
