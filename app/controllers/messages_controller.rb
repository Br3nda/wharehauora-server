class MessagesController < ApplicationController
  def index
    authorize :message
    @messages = policy_scope Message.where(search_params)
                .includes(:sensor)
                .order(created_at: :desc)
                .paginate(page: params[:page])
  end

  def search_params
    params.permit(:sensor_id)
  end
end
