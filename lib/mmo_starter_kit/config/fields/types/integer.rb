require 'rails_admin/config/fields/base'

module MmoStarterKit
  module Config
    module Fields
      module Types
        class Integer < MmoStarterKit::Config::Fields::Base
          # Register field type for the type loader
          MmoStarterKit::Config::Fields::Types.register(self)

          register_instance_option :view_helper do
            :number_field
          end

          register_instance_option :sort_reverse? do
            serial?
          end
        end
      end
    end
  end
end
