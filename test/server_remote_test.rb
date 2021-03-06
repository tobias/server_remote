require 'test_helper'

class ServerRemoteTest < Test::Unit::TestCase
  module ServerRemote::Util
    def execute(cmd)
      cmd
    end

  end


  def run_cmd(args = [])
    ServerRemote::Command.start(TEST_ROOT, args, :config_path => TEST_ROOT + '/config/config_no_override.yml')
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
  
  def test_logtail_action_with_other_log
    assert_equal "ssh -t test 'cd /mnt/app/current;tail -n 500 -f blah'", run_cmd(%w{logtail blah})
  end
  
  def test_cmd_action
    assert_match /^Summary:/, run_cmd(%w{cmd})
    assert_equal "ssh -t test 'cd /mnt/app/current;ls'", run_cmd(%w{cmd ls})
    assert_equal "ssh -t test 'cd /mnt/app/current;ls -p'", run_cmd(%w{cmd ls -p})
    assert_equal "ssh -t test 'cd /mnt/app/current;ls'", run_cmd(%w{-p app cmd ls})
  end
  
  def test_scp_action
    assert_match /^Summary:/, run_cmd(%w{scp})
    assert_equal "scp test:/remote/file /local/file", run_cmd(%w{scp :/remote/file /local/file})
    assert_equal "scp test:/remote/file test:/local/file", run_cmd(%w{scp :/remote/file :/local/file})
  end

end
