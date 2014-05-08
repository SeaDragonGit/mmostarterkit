require 'rails_admin/config/fields/types/has_many_association'

module MmoStarterKit
  module Config
    module Fields
      module Types
        class HasAndBelongsToManyAssociation < MmoStarterKit::Config::Fields::Types::HasManyAssociation
          # Register field type for the type loader
          MmoStarterKit::Config::Fields::Types.register(self)
        end
      end
    end
  end
end
