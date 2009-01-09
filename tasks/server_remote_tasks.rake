require File.dirname(__FILE__) + '/../lib/server_remote/install_tools'

namespace :server_remote do
  desc "Installs the remote script script/ and the example config to config/"
  task :install do
    InstallTools.install
  end

  desc "Removes remote script from script/ and server_remote.yml from config/"
  task :remove do
    InstallTools.remove
  end
end

