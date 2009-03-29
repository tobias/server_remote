$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.join(File.dirname(__FILE__), 'server_remote', 'server_remote')
require File.join(File.dirname(__FILE__), 'server_remote', 'install_tools')


