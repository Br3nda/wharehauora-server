class AuthorizedviewersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize :user
    @authorizedviewers = Authorizedviewer.page(params[:page])
  end

  def new
    authorize :user
    @authorizedviewer = Authorizedviewer.new
  end
end
