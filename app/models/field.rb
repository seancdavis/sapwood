class Field

  include Presenter, ActionView::Helpers

  def initialize(options)
    @attributes ||= options
    self
  end

  def attributes
    @attributes ||= {}
  end

  def type
    attributes['type'] || 'string'
  end

  def label
    attributes['label'] || attributes['name'].humanize.titleize
  end

  def title
    name
  end

  # TODO: Move to a method_missing call

  def document?
    type == 'document'
  end

  def documents?
    type == 'documents'
  end

  def element?
    type == 'element'
  end

  def date?
    type == 'date'
  end

  def primary?
    attributes['primary'].to_bool
  end

  def required?
    attributes['required'].to_bool || primary?
  end

  def method_missing(method, *arguments, &block)
    return attributes[method.to_s] if respond_to?(method.to_s)
    super
  end

  def respond_to?(method, include_private = false)
    attributes.keys.include?(method.to_s)
  end

  def html
    "field_#{type}_html"
  end

  def html_options
    attributes
  end

end
