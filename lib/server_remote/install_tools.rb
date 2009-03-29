module ServerRemote
  class InstallTools

    def self.install(app_root)
      app_cfg_dir = File.join(app_root, 'config')

      FileUtils.mkdir(app_cfg_dir) unless File.exists?(app_cfg_dir)
      
      cp File.join(GEM_ROOT, 'config', 'server_remote.yml.sample'), File.join(app_cfg_dir, 'server_remote.yml')

      app_script_dir = File.join(app_root, 'script')

      FileUtils.mkdir(app_script_dir) unless File.exists?(app_script_dir)
      
      cp File.join(GEM_ROOT, 'script', 'remote'), File.join(app_script_dir, 'remote')
    end

    private
    def self.cp(src, dest)
      if File.exists?(dest)
        puts "File '#{dest}' exists; skipping\n"
      else
        FileUtils.cp src, dest
      end
    end

  end
end
