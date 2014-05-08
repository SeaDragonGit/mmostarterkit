require 'rails_admin/config/model'

module MmoStarterKit
  module Config
    class LazyModel
      def initialize(entity, &block)
        @entity = entity
        @deferred_block = block
      end

      def method_missing(method, *args, &block)
        unless @model
          @model = MmoStarterKit::Config::Model.new(@entity)
          @model.instance_eval(&@deferred_block) if @deferred_block
        end

        @model.send(method, *args, &block)
      end
    end
  end
end
