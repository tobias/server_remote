require File.dirname(__FILE__) + '/test_helper'

require 'pp'

class ServerRemoteUtilTest < Test::Unit::TestCase
  include Remote::Util
  attr_accessor :args
  attr_accessor :options

  def setup
    self.options = {}
  end
  
  def test_load_config_should_load_defaults
    options[:config_path] = TEST_ROOT + '/config/config_no_override.yml'
    load_config 
    assert_equal 'app', config[:profile]
    assert_equal 'production', config[:environment]
  end

  def test_load_config_should_override_defaults
    options[:config_path] = TEST_ROOT + '/config/config_override.yml'
    load_config 
    assert_equal 'test', config[:environment]
  end

  def test_parse_common_args_should_set_profile
    self.config = {}
    self.args =  %w{-p profile}
    parse_common_args
    assert_equal 'profile', config[:profile]
  end
  
  
  def test_user_and_host
    self.config = {:host => 'host'}
    assert_equal 'host', user_and_host

    self.config[:user] = 'user'
    assert_equal '-l user host', user_and_host
  end
  
  def test_keyfile_option
    self.config = {}
    assert_nil keyfile_option

    self.config[:keyfile] = 'kf'
    assert_equal '-i kf ', keyfile_option
  end

  
end
