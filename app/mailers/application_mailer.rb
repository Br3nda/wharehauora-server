# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@wharehauora.nz'
  layout 'mailer'
end
