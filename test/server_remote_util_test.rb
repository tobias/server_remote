require 'test_helper'

class ServerRemoteUtilTest < ActiveSupport::TestCase
  include Remote::Util
  
  def test_load_app_config_should_load_defaults
    load_app_config TEST_ROOT + '/config/config_no_override.yml'
    assert_equal config[:environment], 'production'
  end
end
