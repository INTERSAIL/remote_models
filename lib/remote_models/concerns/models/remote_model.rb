module Intersail
  module RemoteModels
    module RemoteModel
      extend ActiveSupport::Concern
      include Intersail::RemoteModels::RemoteCall

      included do
        include ActiveModel::Model
        include ActiveModel::Serializers::JSON

        class << self
          alias_method :remote_attributes, :attr_accessor
        end
      end

      module ClassMethods
        def all(options={})
          build_call_to_site options
        end

        def first(options={})
          options.store(:limit, 1)
          items = build_call_to_site(options)
          if (items && items.count > 0)
            items[0]
          else
            nil
          end
        end

        private

        def build_call_to_site(options={})
          name = options.delete(:name) || self.name.to_s.underscore
          klass = self.name
          limit = options.delete(:limit) || 0
          from_site(name, klass, limit, nil, nil)
        end
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
