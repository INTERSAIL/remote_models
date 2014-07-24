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
        def from_site(type, klass, limit, where, *ids)
          json = Net::HTTP.get (URI("#{self.site}?type=#{type.to_s}&id=#{ids.join(',') if ids}&where=#{where}&limit=#{limit}"))
          return nil if json.empty?

          objs = ActiveSupport::JSON.decode(json)

          klass = klass.to_s.capitalize.constantize

          objs.map { |o| klass.new.from_json(o.to_json) }
        end
      end
    end
  end
end
