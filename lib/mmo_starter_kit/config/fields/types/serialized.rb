require 'rails_admin/config/fields/types/text'

module MmoStarterKit
  module Config
    module Fields
      module Types
        class Serialized < MmoStarterKit::Config::Fields::Types::Text
          # Register field type for the type loader
          MmoStarterKit::Config::Fields::Types.register(self)

          register_instance_option :formatted_value do
            YAML.dump(value) unless value.nil?
          end

          def parse_input(params)
            if params[name].is_a?(::String)
              params[name] = (params[name].blank? ? nil : (YAML.safe_load(params[name]) || nil))
            end
          end
        end
      end
    end
  end
end
