class Column

  def initialize(options)
    @attributes ||= options
    self
  end

  def attributes
    @attributes ||= {}
  end

  def label
    return attributes['label'] if attributes['label'].present?
    return field.label if name.blank? || name == field.name
    name.humanize.titleize
  end

  # TODO: A better way to do this? `format` is a method on Kernel -- don't want
  # to overwrite it.
  def _format
    attributes['format']
  end

  def primary?
    attributes['primary'].to_bool
  end

  def sort_by
    return field.name unless field.geocode? && _format.present?
    "#{field.name}:#{_format}"
  end

  def output(element)
    return '' if element.send(field.name).blank?
    if field.date?
      begin
        element.send(field.name).strftime(_format || '%b %d, %Y')
      rescue NoMethodError => e
        element.send(field.name)
      end
    elsif field.geocode?
      return element.send(field.name).try(_format) if _format.present?
      element.send(field.name).try(:raw)
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
