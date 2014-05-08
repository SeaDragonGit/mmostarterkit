require 'mmo_starter_kit/engine'
require 'mmo_starter_kit/abstract_model'
require 'mmo_starter_kit/config'
require 'mmo_starter_kit/extension'
require 'mmo_starter_kit/extensions/cancan'
require 'mmo_starter_kit/extensions/paper_trail'
require 'mmo_starter_kit/extensions/history'
require 'mmo_starter_kit/support/csv_converter'
require 'mmo_starter_kit/support/core_extensions'

module MmoStarterKit
  # Setup RailsAdmin
  #
  # Given the first argument is a model class, a model class name
  # or an abstract model object proxies to model configuration method.
  #
  # If only a block is passed it is stored to initializer stack to be evaluated
  # on first request in production mode and on each request in development. If
  # initialization has already occured (in other words RailsAdmin.setup has
  # been called) the block will be added to stack and evaluated at once.
  #
  # Otherwise returns MmoStarterKit::Config class.
  #
  # @see MmoStarterKit::Config
  def self.config(entity = nil, &block)
    if entity
      MmoStarterKit::Config.model(entity, &block)
    elsif block_given?
      block.call(MmoStarterKit::Config)
    else
      MmoStarterKit::Config
    end
  end
end

require 'mmo_starter_kit/bootstrap-sass' unless defined? Bootstrap
