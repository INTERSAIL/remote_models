require "remote_models/version"
require 'remote_models/concerns/models/remote_associable'
require 'remote_models/concerns/models/remote_model'

module RemoteModels
  class Settings
    @@config = {}

    def self.setup(&block)
      yield @@config
    end

    def self.config
      @@config
    end
  end
end
