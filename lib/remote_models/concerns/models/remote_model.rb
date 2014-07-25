module Intersail
  module RemoteModels
    module RemoteModel
      extend ActiveSupport::Concern
      include Intersail::RemoteModels::RemoteCall

      included do
        include ActiveModel::Model
        include ActiveModel::Serializers::JSON

        mattr_accessor :rattrs do
          []
        end
      end

      module ClassMethods
        def remote_attributes(*attr_accessor_args)
          (self.rattrs << attr_accessor_args).flatten!
          attr_accessor *attr_accessor_args
        end

        def remote_fields_param()
          self.rattrs.join(',')
        end

        def all(options={})
          options.replace(limit: 0)
          build_call_to_site options
        end

        def first(options={})
          options.replace(limit: 1)
          items = build_call_to_site(options)
          if (items && items.count > 0)
            items[0]
          else
            nil
          end
        end

        def last(options={})
          options.replace(limit: -1)
          items = build_call_to_site(options)
          if (items && items.count > 0)
            items[0]
          else
            nil
          end
        end

        def where(condition, options={})
          options.store(:where, condition)
          build_call_to_site options
        end

        def order(order_list, options={})
          options.store(:order, order_list)
          build_call_to_site options
        end

        private

        def build_call_to_site(options={})
          name = options.delete(:name) || self.name.to_s.underscore
          klass = self.name
          limit = options.delete(:limit) || 0
          where = options.delete(:where)
          order = options.delete(:order)
          from_site(name, klass, nil, limit, where, order)
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

      def write_attribute(attr_name, value)
        instance_variable_set "@#{attr_name}", value
      end

    end
  end
end
