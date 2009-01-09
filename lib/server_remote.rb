require 'rubygems'
require 'yaml'
require 'simplecli'
require 'hash_ext'

module Remote
  module Util
    attr_accessor :config

    DEFAULT_PROFILE = 'app'
    
    def default_options_path
      File.dirname(__FILE__) + "/../config/defaults.yml"
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
      cd_to_app_action + ";tail -f log/#{config[:environment]}.log"
    end
    
    def load_config(config_path)
      self.config ||= {}
      cfg = YAML.load_file(config_path)
      self.config[:profile] ||= cfg['default_profile'] || DEFAULT_PROFILE
      self.config.merge!(cfg[self.profile].symbolize_keys)
    end
    
    def load_app_config(config_path)
      load_config(default_options_path)
      load_config(config_path)
    end
    
    def parse_common_args(*args)
      # -p profile ; add to config as :default_profile
      
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
#      "-e environment"
    end
    
    def console(*args)
      execute "#{ssh_command} '#{console_action}'"
    end
    
    def logtail_help
 #     "-e environment"
    end
    
    def logtail(*args)
      execute "#{ssh_command} '#{tail_action}'"      
    end

    alias_method :simple_cli_run, :run unless method_defined?(:simple_cli_initialize)
    def run
      #TODO process common args
      #TODO set default command
      load_config("#{RAILS_ROOT}/config/server_remote.yml")
      simple_cli_run
    end


  end

end

