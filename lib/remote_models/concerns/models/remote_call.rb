module Intersail
  module RemoteModels
    module RemoteCall

      extend ActiveSupport::Concern

      included do
        cattr_accessor :site
        cattr_accessor :remote_fields

        self.remote_fields = []

        self.site = ::Intersail::RemoteModels.config.site
      end

      module ClassMethods
        def from_site(type, klass, *ids, limit, where, order)
          klass = klass.to_s.capitalize.constantize

          json = Net::HTTP.get (URI("#{self.site}?type=#{type.to_s}&id=#{ids && ids.join(',')}&where=#{encode_url(where)}&limit=#{limit}&order=#{encode_url(order)}"))
          return nil if json.empty?

          objs = ActiveSupport::JSON.decode(json)


          objs.map { |o| klass.new.from_json(o.to_json) }
        end

        private

        def encode_url(value)
          URI.escape(value) if value
        end
      end
    end
  end
end
