require 'server_remote'
Remote::Command.new(ARGV, :default => 'shell').run
