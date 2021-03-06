require 'rails_admin/config/proxyable/proxy'
module MmoStarterKit
  module Config
    module Proxyable
      attr_accessor :bindings

      def with(bindings = {})
        MmoStarterKit::Config::Proxyable::Proxy.new(self, bindings)
      end
    end
  end
end
