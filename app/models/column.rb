class Column

  def initialize(options)
    @attributes ||= options
    self
  end

  def attributes
    @attributes ||= {}
  end

  def label
    attributes['label'] || field.label
  end

  def primary?
    attributes['primary'].to_bool
  end

  def output(element)
    return '' if element.send(field.name).blank?
    if field.date?
      element.send(field.name).strftime(attributes['format'] || '%b %d, %Y')
    else
      element.send(field.name)
    end
  end

  def method_missing(method, *arguments, &block)
    return attributes[method.to_s] if respond_to?(method.to_s)
    super
  end

  def respond_to?(method, include_private = false)
    attributes.keys.include?(method.to_s)
  end

end
