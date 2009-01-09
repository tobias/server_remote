class InstallTools
  PLUGIN_ROOT = File.dirname(__FILE__) + '/../../'

  def self.install
    cp "#{PLUGIN_ROOT}/config/server_remote.yml.sample", "#{RAILS_ROOT}/config/server_remote.yml"
    cp "#{PLUGIN_ROOT}/script/remote", "#{RAILS_ROOT}/script/remote"
  end

  def self.remove
    rm "#{RAILS_ROOT}/config/server_remote.yml"
    rm "#{RAILS_ROOT}/script/remote"
  end

  private
  def self.cp(src, dest)
    if File.exists?(dest)
      puts "File '#{dest}' exists; skipping\n"
    else
      FileUtils.cp src, dest
    end
  end

  def self.rm(file)
    if File.exists?(file)
      puts "Removing #{file}\n"
      FileUtils.rm file
    end
  end
end


