require 'rubygems'
require 'test/unit'
require 'shoulda'

TEST_ROOT = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'server_remote'

class Test::Unit::TestCase

end
