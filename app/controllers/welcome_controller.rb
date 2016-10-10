# frozen_string_literal: true
class WelcomeController < ApplicationController
  def index
    @public_homes = Home.where(is_public: true).order(:name)
    skip_policy_scope
  end
end
