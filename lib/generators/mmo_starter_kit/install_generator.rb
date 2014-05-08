require 'rails/generators'
require File.expand_path('../utils', __FILE__)

module MmoStarterKit
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    include Generators::Utils::InstanceMethods

    argument :_namespace, type: :string, required: false, desc: 'RailsAdmin url namespace'
    desc 'RailsAdmin installation generator'

    def install
      namespace = ask_for('Where do you want to mount mmo_starter_kit?', 'admin', _namespace)
      route("mount MmoStarterKit::Engine => '/#{namespace}', as: 'mmo_starter_kit'")
      template 'initializer.erb', 'config/initializers/mmo_starter_kit.rb'
    end
  end
end
