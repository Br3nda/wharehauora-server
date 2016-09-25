class Web::ReadingsController < WebController
  before_action :authenticate_user!
  def index
    @readings = policy_scope(Reading)
  end

  def show
    @reading = Reading.find(params[:id])
    authorize @reading
  end
end
