require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FightClub
  class Application < Rails::Application

    config.eager_load_paths += %W(#{config.root}/app/models/gears)
    config.eager_load_paths += %W(#{config.root}/lib/fight_modules)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
