require "remote_models/version"
require 'remote_models/concerns/models/remote_associable'
require 'remote_models/concerns/models/remote_model'

module Intersail
  module RemoteModels
    @@config = Settings.new

    def self.setup(&block)
      yield @@config
    end

    def self.config
      @@config
    end

    class Settings
      @config = {}

      def site
        @config[:site]
      end
      def site=(value)
        @config[:site] = value
      end
    end
  end
end