require 'rubygems'
require 'optparse'
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
      user = "-l #{config[:user]} " if config[:user]
      "#{user}#{config[:host]}"
    end

    def keyfile_option
      "-i #{config[:keyfile]} " if config[:keyfile]
    end
    
    def ssh_command
      "ssh -t #{keyfile_option}#{user_and_host}"
    end

    def console_action
      cd_to_app_action + ";./script/console #{config[:environment]}"
    end

    def cd_to_app_action
      "cd #{config[:app_path]}"
    end

    def tail_action
      cd_to_app_action + ";tail -n #{config[:tail_initial_lines]} -f log/#{config[:environment]}.log"
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
      if args.shift == '-p'
        p = args.shift
        if p
          config[:profile] = p
        else
          raise "Missing profile argument for -p"
        end
      end
#       opts = OptionParser.new do |opts|
#         opts.on('-p PROFILE') { |p| config[:profile] = p }
#       end
#       opts.parse!(args)
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
      execute "#{ssh_command} '#{console_action}'"
    end
    
    def logtail_help
      'Summary: executes remote tail -f on the log'
    end
    
    def logtail(*args)
      execute "#{ssh_command} '#{tail_action}'"      
    end

    def cmd_help
      %{
Summary: executes an arbitrary command on the server

usage: #{script_name} cmd <command>
}
    end

    def cmd(*args)
      if args.empty?
        cmd_help
      else
        execute "#{ssh_command} '#{args.join(' ')}'"
      end
    end
    
    
   #  alias_method :simple_cli_parse!, :parse! unless method_defined?(:simple_cli_parse!)
#     def parse!
#       parse_common_args(args)
#       load_config(config_path)
#       simple_cli_parse!
   # end

    def self.start(args, options = {})
      remote = new(args.empty? ? ['--nullarg'] : args, options.merge(:default => 'shell'))
      remote.parse_common_args
      remote.load_config
      remote.parse!
      remote.run
    end

  end

end

