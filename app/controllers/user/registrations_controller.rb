# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  layout 'devise', only: [:edit]
end
