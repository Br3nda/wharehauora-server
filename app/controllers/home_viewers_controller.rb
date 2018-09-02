# frozen_string_literal: true

class HomeViewersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_home, only: %i[create index new destroy]

  def index
    authorize @home, :edit?
    @viewers = policy_scope(HomeViewer)
               .includes(:user)
               .where(home_id: params[:home_id])
               .page(params[:page])
    @invitations = @home.invitations.pending
  end

  def new
    authorize @home, :edit?
    @home_viewer = Invitation.new
  end

  def create
    byebug
    authorize @home, :edit?
    @invitation = @home.invitations.create!(
      inviter: current_user,
      email: viewer_params[:email]
    )
    InvitationMailer.invitation_email(@invitation).deliver_now
    redirect_to home_home_viewers_path(@home)
  end

  def destroy
    authorize @home, :edit?
    viewer = @home.home_viewers.find_by!(user_id: params[:id])
    viewer.destroy
  ensure
    redirect_to home_home_viewers_path(@home)
  end


  def accept
    @home = @invitation.home
    @home.home_viewers.create!(user: current_user)
    @invitation.accepted!
    redirect_to home_path(@home)
  end

  def decline
    @home = @invitation.home
    @invitation.declined!
    redirect_to root_path
  end

  private

  def set_home
    @home = policy_scope(Home).find(params[:home_id])
  end

  def invite_user; end

  def viewer_params
    params.require(:invitation).permit(permitted_params)
  end

  def permitted_params
    %i[
      id
      email
      home_id
    ]
  end
end
