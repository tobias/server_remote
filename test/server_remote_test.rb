require File.dirname(__FILE__) + '/test_helper'

require 'pp'

class ServerRemoteTest < Test::Unit::TestCase
  
  module Remote::Util
    def execute(cmd)
      cmd
    end

    RAILS_ROOT = 'blah'
  end


  def run_cmd(args = [])
    Remote::Command.start(args, :config_path => TEST_ROOT + '/config/config_no_override.yml')
  end


  def test_shell_action
    assert_equal 'ssh -t test', run_cmd
    assert_equal 'ssh -t test', run_cmd(%w{-p app})
  end
  
  def test_console_action
    assert_equal "ssh -t test 'cd /mnt/app/current;./script/console production'", run_cmd(%w{console})
  end

  def test_logtail_action
    assert_equal "ssh -t test 'cd /mnt/app/current;tail -n 500 -f log/production.log'", run_cmd(%w{logtail})
  end

  def test_cmd_action
    assert_match /^Summary:/, run_cmd(%w{cmd})
    assert_equal "ssh -t test 'ls'", run_cmd(%w{cmd ls})
    assert_equal "ssh -t test 'ls -p'", run_cmd(%w{cmd ls -p})
    assert_equal "ssh -t test 'ls'", run_cmd(%w{-p app cmd ls})
  end
  
  def test_cmd_in_app_action
    assert_match /^Summary:/, run_cmd(%w{cmd_in_app})
    assert_equal "ssh -t test 'cd /mnt/app/current;ls'", run_cmd(%w{cmd_in_app ls})
#     assert_equal "ssh -t test 'ls -p'", run_cmd(%w{cmd ls -p})
#     assert_equal "ssh -t test 'ls'", run_cmd(%w{-p app cmd ls})
  end
    
  def test_scp_action
#    assert_match /^Summary:/, run_cmd(%w{scp})
  end
  
end
