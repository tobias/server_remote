# ServerRemote

require 'rubygems'
require 'yaml'
require 'simplecli'
require 'hash_ext'

module Remote
  module Util
    attr_accessor :config
    attr_accessor :profile

    DEFAULT_PROFILE = 'app'
    
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
      cd_to_app_action + ";tail -f log/#{config[:environment]}.log"
    end
    
    def load_config(config_path, profile = nil)
      cfg = YAML.load_file(config_path)
      self.profile = profile || cfg['default_profile'] || DEFAULT_PROFILE
      self.config = cfg[self.profile].symbolize_keys
    end

    def parse_common_args(*args)
    end
    

  end
    
  class Command
    include SimpleCLI
    include Util
    
    def shell_help
    end
    
    def shell(*args)
      execute ssh_command
    end
    
    def console_help
    end
    
    def console(*args)
      execute "#{ssh_command} '#{console_action}'"
    end
    
    def logtail_help

    end
    
    def logtail(*args)
      execute "#{ssh_command} '#{tail_action}'"      
    end

    alias_method :simple_cli_run, :run unless method_defined?(:simple_cli_initialize)
    def run
      #TODO process common args 
      load_config("#{RAILS_ROOT}/config/server_remote.yml")
      simple_cli_run
    end


  end

end

