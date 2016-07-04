module SapwoodConfigHelpers

  def remove_config
    file = SapwoodConfig.file
    FileUtils.rm(file)
    Sapwood.reload!
  end

  def template_config_file
    File.expand_path('../template_config.json', __FILE__)
  end

  def collection_type_config_file
    File.expand_path('../collection_type_config.json', __FILE__)
  end

  def add_test_config
    settings = File.expand_path('../sapwood.test.yml', __FILE__)
    FileUtils.cp(settings, "#{Rails.root}/config/sapwood.test.yml")
    Sapwood.reload!
  end

end
