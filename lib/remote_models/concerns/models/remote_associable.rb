module RemoteAssociable
  extend ActiveSupport::Concern

  included do
    cattr_accessor :site
    cattr_accessor :remote_fields

    self.remote_fields = []
  end

  module ClassMethods
    def has_one_remote(field, options={})
      self.remote_fields.delete(field)

      fk_name = options.delete(:foreign_key) || "#{field}_id"
      klass = options.delete(:class) || field.capitalize
      name = options.delete(:name) || field.to_s
      var_name = "@#{field}"

      define_method field do
        unless instance_variable_defined?(var_name)
          fk_value = send(fk_name)
          value = fk_value<=0 ? nil : from_site(name, klass, fk_value)
          instance_variable_set(var_name, value && value.first)
        end
        instance_variable_get(var_name)
      end

      # alias_method "orig_#{fk_name}=", "#{fk_name}="
      # define_method "#{fk_name}=" do |value|
      #   var_name = "@#{field}"
      #   remove_instance_variable(var_name) if instance_variable_defined?(var_name)
      #   send "orig_#{fk_name}=", value
      # end

      self.remote_fields << field
    end
  end

  private

  def from_site(type, klass, *ids)
    json = Net::HTTP.get (URI("#{self.site}?type=#{type.to_s}&id=#{ids.join(',')}"))
    return nil if json.empty?

    objs = ActiveSupport::JSON.decode(json)

    klass = type.to_s.capitalize.constantize

    objs.map { |o| klass.new.from_json(o.to_json) }
  end
end