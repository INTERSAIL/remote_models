require "remote_models/version"
require 'settings'
require 'remote_models/concerns/models/remote_call'
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
  end
end
