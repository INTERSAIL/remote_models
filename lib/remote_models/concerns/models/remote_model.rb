module Intersail
  module RemoteModels
    module RemoteModel
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Model
        include ActiveModel::Serializers::JSON

        class << self
          alias_method :remote_attributes, :attr_accessor
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
    end
  end
end
