class Sapwood

  def self.write_config!
    config = sapwood_as_hash.to_yaml
    File.open(config_file, 'w+') { |f| f.write(config) }
  end

  private

    def self.config_file
      File.join(Rails.root,'config','sapwood.yml')
    end

end
