class Property::Template

  def initialize(options)
    @attributes ||= options
    self
  end

  def attributes
    @attributes ||= {}
  end

  def name
    title
  end

  def element_title_label
    attributes['element_title_label'] || 'Title'
  end

  def show_body?
    attributes['body'].nil? ? true : attributes['body'].to_bool
  end

  def fields
    return {} unless attributes['fields']
    fields = []
    attributes['fields'].each do |name, data|
      fields << Property::Template::Field.new(data.merge('name' => name))
    end
    fields
  end

  def find_field(name)
    fields.select { |f| f.name == name }.first
  end

  def geocode_fields
    fields.select { |f| f.type == 'geocode' }
  end

  def method_missing(method, *arguments, &block)
    return attributes[method.to_s] if respond_to?(method.to_s)
    return {} if method.to_s == 'fields'
    super
  end

  def respond_to?(method, include_private = false)
    attributes.keys.include?(method.to_s)
  end

end
