class Property::Template::Field

  include Presenter

  def initialize(options)
    @attributes ||= options
    self
  end

  def attributes
    @attributes ||= {}
  end

  def type
    attributes['type']
  end

  def label
    attributes['label'] || attributes['name'].titleize
  end

  def title
    name
  end

  def method_missing(method, *arguments, &block)
    return attributes[method.to_s] if respond_to?(method.to_s)
    super
  end

  def respond_to?(method, include_private = false)
    attributes.keys.include?(method.to_s)
  end

  def html(form_obj)
    form_obj.input name.to_sym, :required => false
  end

end
