# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[
  detectizr-2.1.0.min.js jquery-2.1.3.min.js jquery.magnific-popup.min.js jquery-ui-widget.min.js ratings.js tooltipster.bundle.min.js
  application.js init.js jquery.icheck.min.js jquery.selectBoxIt.min.js modernizr-2.8.3.js
]
