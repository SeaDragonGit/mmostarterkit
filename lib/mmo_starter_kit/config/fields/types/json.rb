require 'rails_admin/config/fields/types/text'

module MmoStarterKit
  module Config
    module Fields
      module Types
        class Json < MmoStarterKit::Config::Fields::Types::Text
          # Register field type for the type loader
          MmoStarterKit::Config::Fields::Types.register(self)

          register_instance_option :formatted_value do
            value.present? ? JSON.pretty_generate(value) : nil
          end

          def parse_input(params)
            if params[name].is_a?(::String)
              params[name] = (params[name].blank? ? nil : JSON.parse(params[name]))
            end
          end
        end
      end
    end
  end
end
