module Intersail
  module RemoteModels
    module RemoteCall

      def from_site(type, klass, *ids, limit, where, order)
        # klass deve essere del tipo "TizioCaio", quindi per sicurezza prendo il parametro klass e ne faccio il titleize (che quindi lo divide in parole), poi rimuovo gli spazi
        klass = klass.to_s.titleize.split.join("").constantize

        site = ::Intersail::RemoteModels.config.site

        json = Net::HTTP.get (URI("#{site}?type=#{type.to_s}&id=#{ids && ids.join(',')}&where=#{encode_url(where)}&limit=#{limit}&order=#{encode_url(order)}&fields=#{klass.remote_fields_param}"))
        return nil if json.empty?

        objs = ActiveSupport::JSON.decode(json)

        objs.map { |o| klass.new.from_json(o.to_json) }
      end

      def build_call_to_site(option={})
        name = option.delete(:name) || self.name.to_s.underscore
        klass = option.delete(:klass) || self.name
        limit = option.delete(:limit)
        where = option.delete(:where)
        order = option.delete(:order)
        ids = option.delete(:ids)
        from_site(name, klass, ids, limit, where, order)
      end

      private

      def encode_url(value)
        URI.escape(value) if value
      end
    end
  end
end