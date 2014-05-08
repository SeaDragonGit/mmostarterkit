if defined?(::ActiveRecord)
  module ActiveRecord
    class Base
      def self.mmo_starter_kit(&block)
        MmoStarterKit.config(self, &block)
      end

      def mmo_starter_kit_default_object_label_method
        self.new_record? ? "new #{self.class}" : "#{self.class} ##{id}"
      end

      def safe_send(value)
        if self.has_attribute?(value)
          read_attribute(value)
        else
          send(value)
        end
      end
    end
  end
end
