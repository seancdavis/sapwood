require 'fileutils'

class SapwoodConfig

  def config_to_h
    @config_to_h ||= reload!
  end

  def config
    config_to_h.to_ostruct
  end

  def write!
    config = config_to_h.to_yaml
    File.open(SapwoodConfig.file, 'w+') { |f| f.write(config) }
    reload!
  end

  def reload!
    @config_to_h = default_settings.merge(YAML.load_file(SapwoodConfig.file))
  end

  def installed?
    begin
      config.installed?
    rescue
      false
    end
  end

  def self.file
    file = File.join(Rails.root, 'config', "sapwood.#{Rails.env.to_s}.yml")
    FileUtils.cp(default_file, file) unless File.exists?(file)
    file
  end

  def self.default_file
    File.join(Rails.root, 'config', "sapwood.default.yml")
  end

  private

    def default_settings
      { 'installed?' => false, 'version' => '2.0' }
    end

end

Sapwood = SapwoodConfig.new
