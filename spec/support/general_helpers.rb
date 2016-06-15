module GeneralHelpers

  def property_with_templates
    create(:property, :templates_raw => File.read(template_config_file))
  end

  def example_image_url
    'https://s-media-cache-ak0.pinimg.com/custom_covers/30x30/178947853882959841_1454569459.jpg'
  end

end
