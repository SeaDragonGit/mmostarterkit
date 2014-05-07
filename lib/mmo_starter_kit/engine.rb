require 'font-awesome-rails'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'kaminari'
require 'nested_form'
require 'rack-pjax'
require 'rails'
require 'rails_admin'
require 'remotipart'
require 'safe_yaml'

SafeYAML::OPTIONS[:suppress_warnings] = true
SafeYAML::OPTIONS[:default_mode] = :unsafe

module MmoStarterKit
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin
    initializer 'RailsAdmin precompile hook', group: :all do |app|
      app.config.assets.precompile += %w[
        mmo_starter_kit/mmo_starter_kit.js
        mmo_starter_kit/mmo_starter_kit.css
        mmo_starter_kit/jquery.colorpicker.js
        mmo_starter_kit/jquery.colorpicker.css
      ]
    end

    initializer 'RailsAdmin pjax hook' do |app|
      app.config.middleware.use Rack::Pjax
    end

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), '../tasks/*.rake')].each { |f| load f }
    end
  end
end
