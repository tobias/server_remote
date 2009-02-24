require 'rubygems'
require 'yaml'
require 'simplecli'
require 'hash_ext'

module Remote
  module Util
    attr_accessor :config

    DEFAULT_PROFILE = 'app'
    PLUGIN_ROOT = File.dirname(__FILE__)
    
    def default_options_path
      PLUGIN_ROOT + "/../config/defaults.yml"
    end
    
    def execute(cmd)
      print "#{cmd}\n"
      Kernel.system(cmd)
    end

    def user_and_host
      user = "#{config[:user]}@" if config[:user]
      "#{user}#{config[:host]}"
    end

    def keyfile_option
      "-i #{config[:keyfile]} " if config[:keyfile]
    end
    
    def ssh_command
      "ssh -t #{keyfile_option}#{user_and_host}"
    end
    
    def scp_command
      "scp #{keyfile_option}"
    end

    def scp_file_argument(arg)
      if arg and arg[0..0] == ':'
        user_and_host + arg
      else
        arg
      end
    end
    
    def console_action
      "./script/console #{config[:environment]}"
    end

    def cd_to_app_action
      "cd #{config[:app_path]}"
    end

    def tail_action
      "tail -n #{config[:tail_initial_lines]} -f log/#{config[:environment]}.log"
    end

    def remote_command(args)
      args = args.join(' ') if args.respond_to?(:join)
      "#{ssh_command} '#{args}'"
    end

    def remote_command_in_app(args)
      args = args.join(' ') if args.respond_to?(:join)
      remote_command("#{cd_to_app_action};#{args}")
    end
    
    def config
      @config ||= {}
    end

    def config_path
      options[:config_path] ? options[:config_path] : "#{RAILS_ROOT}/config/server_remote.yml"
    end

    def load_config
      load_default_config
      load_app_config(config_path)
    end
    
    def parse_common_args
      if args.first == '-p'
        args.shift
        p = args.shift
        if p
          config[:profile] = p
        else
          raise "Missing profile argument for -p"
        end
      end
      
      # get around simplecli's usage call when there are no arguments
      # instead of calling the default action
      args << '--nullarg' if args.empty?
    end

    protected

    def load_app_config(config_path)
      cfg = YAML.load_file(config_path)
      self.config[:profile] ||= cfg['default_profile'] || DEFAULT_PROFILE
      if cfg[config[:profile]]
        self.config.merge!(cfg[config[:profile]].symbolize_keys)
      else
        raise "No profile '#{config[:profile]}' exists in #{config_path}"
      end      
    end
    
    def load_default_config
      self.config.merge!(YAML.load_file(default_options_path).symbolize_keys)
    end


  end
    
  class Command
    include SimpleCLI
    include Util
    
    def usage_help
      "Summary: prints usage message"
    end
    
    def usage
      puts <<EOH
Executes commands on a remote server over ssh. Configuration is in:
#{RAILS_ROOT}/config/server_remote.yml

You can override the profile used with -p profile. The default profile is: #{config[:profile]}

Learn more in the readme:
#{PLUGIN_ROOT}/README.textile

EOH

      commands
    end
    
    def shell_help
      "Summary: executes remote shell"
    end
    
    def shell(*args)
      execute ssh_command
    end
    
    def console_help
      'Summary: executes remote console'
    end
    
    def console(*args)
      execute remote_command_in_app(console_action)
    end
    
    def logtail_help
      'Summary: executes remote tail -f on the log'
    end
    
    def logtail(*args)
      execute remote_command_in_app(tail_action)
    end

    def cmd_help
      %{
Summary: executes an arbitrary command on the server after a cd to the app path

usage: #{script_name} cmd <command>
}
    end

    def cmd(*args)
      if args.empty?
        cmd_help
      else
        execute remote_command_in_app(args)
      end
    end
    
    def scp_help
       %{
Summary: copies files over scp (prefix remote files with ':')

usage: #{script_name} scp <file1> <file2>

Example:

#{script_name} scp /local/file :/remote/file executes:
scp /local/file user@host:/remote/file

Any non colon prefixed arguments will be passed to scp.
}
    end
    
    def scp(*args)
      if args.empty?
        scp_help
      else
        execute scp_command + args.collect { |f| scp_file_argument(f) }.join(' ')
      end
    end
    
    
    def self.start(args, options = {})
      remote = new(args, options.merge(:default => 'shell'))
      remote.parse_common_args
      remote.load_config
      remote.parse!
      remote.run
    end

  end

end

