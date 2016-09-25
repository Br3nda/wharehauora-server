if Rails.env.production?
  Raygun.setup do |config|
    config.filter_parameters = Rails.application.config.filter_parameters

    if ENV['RAILS_SERVE_STATIC_FILES'].present?
      config.api_key ENV['RAILS_SERVE_STATIC_FILES']
      config.enable_reporting = true
    else
      config.enable_reporting = false
    end
  end
end
