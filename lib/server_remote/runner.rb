require 'server_remote'
Remote::Command.new(ARGV.empty? ? ['--nullarg'] : ARGV, :default => 'shell').run
