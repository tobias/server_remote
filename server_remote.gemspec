# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{server_remote}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["tobias"]
  s.date = %q{2009-03-28}
  s.email = %q{tcrawley@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "README.textile", "LICENSE"]
  s.files = ["README.rdoc", "README.textile", "VERSION.yml", "lib/hash_ext.rb", "lib/server_remote", "lib/server_remote/install_tools.rb", "lib/server_remote/server_remote.rb", "lib/server_remote.rb", "test/config", "test/config/config_no_override.yml", "test/config/config_override.yml", "test/config/defaults.yml", "test/server_remote_test.rb", "test/server_remote_util_test.rb", "test/test_helper.rb", "config/defaults.yml", "config/server_remote.yml.sample", "script/remote", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tobias/server_remote}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
