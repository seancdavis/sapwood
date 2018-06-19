# frozen_string_literal: true

class Field

  include ActionView::Helpers

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

  # Whether or not we should fallback to method_missing for this particular
  # field.
  def sendable?
    document? || documents? || element? || elements? || boolean?
  end

  def format
    attributes['format'] unless date?
    attributes['format'] || 'mm-dd-yyyy'
  end

  def primary?
    attributes['primary'].to_bool
  end

  def required?
    attributes['required'].to_bool || primary?
  end

  def read_only?
    attributes['read_only'].to_bool || attributes['readonly'].to_bool
  end

  def method_missing(method, *arguments, &block)
    return attributes[method.to_s] if respond_to?(method.to_s)
    return type == method.to_s.chomp('?') if method.to_s.end_with?('?')
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
