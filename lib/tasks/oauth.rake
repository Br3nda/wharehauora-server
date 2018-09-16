# frozen_string_literal: true

namespace :oauth do
  USAGE = 'rake oauth:application name=[YOUR APP NAME] redirect_uri=[YOUR REDIRECT URI,
           defaults to "urn:ietf:wg:oauth:2.0:oob"'
  desc 'Create a Doorkeeper application for use with OAuth'
  task application: :environment do
    app_name = ENV['name'] || raise("Please specify the name of the OAuth application: #{USAGE}")
    redirect_uri = ENV['redirect_uri'] || 'urn:ietf:wg:oauth:2.0:oob'
    app = Doorkeeper::Application.create!(name: app_name, redirect_uri: redirect_uri)
    puts "Created app! Your client ID is:\n\t#{app.uid}.\nYour client secret is:\n\t#{app.secret}"
    puts "If you need to find these details again, your application is ID##{app.id}"
  end
end
