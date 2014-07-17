module Intersail
  module RemoteModels
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