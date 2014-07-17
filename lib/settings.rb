module Intersail
  module RemoteModels
    class Settings
      def initialize
        @config = {}
      end

      def site
        @config[:site]
      end
      def site=(value)
        @config[:site] = value
      end
    end
  end
end