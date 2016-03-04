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

  def fields
    return {} unless attributes['fields']
    fields = []
    attributes['fields'].each do |name, data|
      fields << Property::Template::Field.new(data.merge('name' => name))
    end
    fields
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