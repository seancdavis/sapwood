# frozen_string_literal: true

module GeneralHelpers
  def property_with_templates
    create(:property, templates_raw: File.read(template_config_file))
  end

  def property_with_template_file(filename)
    config_file = File.expand_path("../#{filename}.json", __FILE__)
    create(:property, templates_raw: File.read(config_file))
  end

  def example_image_url
    'https://s-media-cache-ak0.pinimg.com/custom_covers/30x30/178947853882959841_1454569459.jpg'
  end

  def template_config_file
    File.expand_path('./template_config.json', __dir__)
  end
end
