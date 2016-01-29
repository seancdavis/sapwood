module SapwoodConfigHelpers

  def remove_config
    file = SapwoodConfig.file
    FileUtils.rm(file)
    Sapwood.reload!
  end

end
