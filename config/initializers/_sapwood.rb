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
    config = { 'installed?' => false, 'version' => '2.0' }
    @config_to_h = config.merge(YAML.load_file(SapwoodConfig.file))
  end

  def installed?
    begin
      config.installed?
    rescue
      false
    end
  end

  def self.file
    filename = Rails.env.test? ? 'sapwood.test.yml' : 'sapwood.yml'
    file = File.join(Rails.root, 'config', filename)
    raise "Missing config file: #{file}" unless File.exists?(file)
    file
  end

end

Sapwood = SapwoodConfig.new
