require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/password'

# Register a custom field factory for properties named as password. More property
# names can be registered in MmoStarterKit::Config::Fields::Password.column_names
# array.
#
# @see MmoStarterKit::Config::Fields::Types::Password.column_names
# @see MmoStarterKit::Config::Fields.register_factory
MmoStarterKit::Config::Fields.register_factory do |parent, properties, fields|
  if [:password].include?(properties.name)
    fields << MmoStarterKit::Config::Fields::Types::Password.new(parent, properties.name, properties)
    true
  else
    false
  end
end
