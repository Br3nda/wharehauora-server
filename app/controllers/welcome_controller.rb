# frozen_string_literal: true
class WelcomeController < ApplicationController
  def index
    skip_policy_scope
  end
end
