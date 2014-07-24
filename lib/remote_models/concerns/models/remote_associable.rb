module Intersail
  module RemoteModels
    module RemoteAssociable

      extend ActiveSupport::Concern
      include Intersail::RemoteModels::RemoteCall

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
              value = fk_value<=0 ? nil : from_site(name, klass, 0, nil, fk_value)
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
              # se è definito il parametro "through" significa che si tratta di una relazione N-M, quindi devo recuperare tutti gli ids dell'associazione contenuti nella tabella intermedia
              ids = send(through).map { |o| o.send(fk_name) } if through
              # se invece non è definito il parametro "through" significa che si tratta di una relazione 1-N, quindi devo recuperare gli elementi che hanno la foreign key indicata nella relazione
              where = "#{fk_name} eq #{send(id)}" unless through
              instance_variable_set(var_name, from_site(name, klass, 0, where, ids))
            end
            instance_variable_get(var_name)
          end
        end
      end
    end
  end
end
