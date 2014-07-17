module Intersail
  module RemoteModels
    module RemoteAssociable

      extend ActiveSupport::Concern

      included do
        cattr_accessor :site
        cattr_accessor :remote_fields

        self.remote_fields = []

        self.site = RemoteModels::Settings.config[:site]
      end

      module ClassMethods
        def has_one_remote(field, options={})
          self.remote_fields.delete(field)

          fk_name = options.delete(:foreign_key) || "#{field}_id"
          name = options.delete(:name) || field.to_s
          klass = options.delete(:class) || name.to_s.capitalize
          var_name = "@#{field}"

          define_method field do
            unless instance_variable_defined?(var_name)
              fk_value = send(fk_name)
              value = fk_value<=0 ? nil : from_site(name, klass, fk_value)
              instance_variable_set(var_name, value && value.first)
            end
            instance_variable_get(var_name)
          end

          define_method "#{fk_name}=" do |value|
            var_name = "@#{field}"
            remove_instance_variable(var_name) if instance_variable_defined?(var_name)
            write_attribute fk_name, value
          end

          self.remote_fields << field
        end

        def has_many_remote(field, options={})
          through = options.delete(:through)
          name = options.delete(:name) || field.to_s.singularize
          klass = options.delete(:class) || name.to_s.capitalize
          fk_name = options.delete(:foreign_key) || "#{field.to_s.singularize}_id"
          var_name = "@#{field}"

          define_method field do
            unless instance_variable_defined?(var_name)
              ids = send(through).map { |o| o.send(fk_name) }
              instance_variable_set(var_name, from_site(name, klass, ids))
            end
            instance_variable_get(var_name)
          end
        end
      end

      private

      def from_site(type, klass, *ids)
        json = Net::HTTP.get (URI("#{self.site}?type=#{type.to_s}&id=#{ids.join(',')}"))
        return nil if json.empty?

        objs = ActiveSupport::JSON.decode(json)

        klass = klass.to_s.capitalize.constantize

        objs.map { |o| klass.new.from_json(o.to_json) }
      end
    end
  end
end
