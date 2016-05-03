module GeneralHelpers

  def property_with_templates
    create(:property, :templates_raw => File.read(template_config_file))
  end

end
