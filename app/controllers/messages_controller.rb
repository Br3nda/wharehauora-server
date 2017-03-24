class MessagesController < ApplicationController
  def index
    @message = policy_scope(Message)
  end
end
