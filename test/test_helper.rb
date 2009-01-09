require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'test/unit'

TEST_ROOT = File.dirname(__FILE__) unless defined?(TEST_ROOT)
$LOAD_PATH.unshift "#{TEST_ROOT}/../lib" 

require 'server_remote'

