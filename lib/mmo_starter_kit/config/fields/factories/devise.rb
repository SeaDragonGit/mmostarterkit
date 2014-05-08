require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/password'

# Register a custom field factory for devise model
MmoStarterKit::Config::Fields.register_factory do |parent, properties, fields|
  if properties.name == :encrypted_password
    extensions = [:password_salt, :reset_password_token, :remember_token]
    fields << MmoStarterKit::Config::Fields::Types.load(:password).new(parent, :password, properties)
    fields << MmoStarterKit::Config::Fields::Types.load(:password).new(parent, :password_confirmation, properties)
    extensions.each do |ext|
      properties = parent.abstract_model.properties.detect { |p| ext == p.name }
      if properties
        unless field = fields.detect { |f| f.name == ext }
          MmoStarterKit::Config::Fields.default_factory.call(parent, properties, fields)
          field = fields.last
        end
        field.hide
      end
    end
    true
  else
    false
  end
end
