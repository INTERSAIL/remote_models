module Intersail
  module RemoteModels
    module RemoteModel
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Model
        include ActiveModel::Serializers::JSON

        mattr_accessor :rattrs do
          []
        end

        class << self
          def remote_attributes(*attr_accessor_args)
            (self.rattrs << attr_accessor_args).flatten!
            attr_accessor *attr_accessor_args
          end
          # alias_method :remote_attributes, :attr_accessor
        end
      end

      module ClassMethods
      end

      def attributes=(hash)
        hash.each do |key, value|
          send("#{key}=", value)
        end
      end

      def attributes
        instance_values
      end

      def write_attribute(attr_name, value)
        instance_variable_set "@#{attr_name}", value
      end
    end
  end
end
