require File.dirname(__FILE__) + '/../../../config/boot'
require File.dirname(__FILE__) + '/lib/server_remote/install_tools'
InstallTools.install

begin
  require 'simplecli'
rescue LoadError
  puts "\n\n>>> This plugin requires the simplecli gem. Install with 'gem install remi-simplecli'. <<<\n\n"
end

