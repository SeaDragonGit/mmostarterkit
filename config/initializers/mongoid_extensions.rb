if defined?(::Mongoid::Document)
  require 'mmo_starter_kit/adapters/mongoid/extension'
  Mongoid::Document.send(:include, MmoStarterKit::Adapters::Mongoid::Extension)
end
