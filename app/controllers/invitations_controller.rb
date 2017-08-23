# frozen_string_literal: true

class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_home, only: %i[create destroy]
  before_action :set_invitation, only: %i[show accept decline destroy]
  skip_after_action :verify_authorized, only: %i[show accept decline]

  def show; end

  def create
    authorize @home, :edit?
    @invitation = @home.invitations.create!(
      inviter: current_user,
      email: params[:invitation][:email]
    )
    # TODO: send invitation notification/instructions
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

  def destroy
    authorize @home, :edit?
    @invitation.destroy if @invitation.present?
    redirect_to home_home_viewers_path(@home)
  end

  private

  def set_home
    @home = policy_scope(Home).find(params[:home_id])
  end

  def set_invitation
    @invitation = Invitation.find_by(token: params[:id])
  end
end
