require 'rails_admin/config/fields/base'

module MmoStarterKit
  module Config
    module Fields
      module Types
        class Decimal < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)
        end
      end
    end
  end
end
