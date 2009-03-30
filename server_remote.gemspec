# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{server_remote}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tobias Crawley"]
  s.date = %q{2009-03-30}
  s.default_executable = %q{server_remotify}
  s.email = %q{tcrawley@gmail.com}
  s.executables = ["server_remotify"]
  s.extra_rdoc_files = ["README.textile", "LICENSE"]
  s.files = ["README.textile", "VERSION.yml", "bin/server_remotify", "config/defaults.yml", "config/server_remote.yml.sample", "lib/hash_ext.rb", "lib/server_remote", "lib/server_remote/install_tools.rb", "lib/server_remote/server_remote.rb", "lib/server_remote.rb", "test/config", "test/config/config_no_override.yml", "test/config/config_override.yml", "test/config/defaults.yml", "test/server_remote_test.rb", "test/server_remote_util_test.rb", "test/test_helper.rb", "script/remote", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tobias/server_remote}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A gem that provides script/remote to a project for executing remote commands.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<remi-simplecli>, [">= 0.1.5"])
    else
      s.add_dependency(%q<remi-simplecli>, [">= 0.1.5"])
    end
  else
    s.add_dependency(%q<remi-simplecli>, [">= 0.1.5"])
  end
end
