# frozen_string_literal: true
class Web::RoomsController < WebController
  before_action :authenticate_user!

  def index
    @rooms = policy_scope(Room)
  end

  def show
    @room = Home.find(params[:id])
    authorize @room
  end
end
