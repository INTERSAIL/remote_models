module Intersail
  module RemoteModels
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path('../../templates', __FILE__)
        desc 'Creates RemoteModels initializer for your application'

        def copy_initializer
          template 'remote_models_initializer.rb', 'config/initializers/remote_models.rb'

          puts 'Install complete!'
        end
      end
    end
  end
end