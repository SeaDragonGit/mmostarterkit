require 'rails_admin/config/fields/types/datetime'

module MmoStarterKit
  module Config
    module Fields
      module Types
        class Timestamp < MmoStarterKit::Config::Fields::Types::Datetime
          # Register field type for the type loader
          MmoStarterKit::Config::Fields::Types.register(self)

          @format = :long
          @i18n_scope = [:time, :formats]
          @js_plugin_options = {}
        end
      end
    end
  end
end
