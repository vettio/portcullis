require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

Bundler.require(:default, Rails.env)

module Portcullis
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'
    config.autoload_paths += %W({config.root}/lib)
    require "#{Rails.root}/lib/net/http/response"
  end
end
