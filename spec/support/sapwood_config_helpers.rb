module SapwoodConfigHelpers

  def remove_config
    file = SapwoodConfig.file
    FileUtils.rm(file)
    Sapwood.reload!
  end

  def template_config_file
    File.expand_path('../template_config.json', __FILE__)
  end

end
