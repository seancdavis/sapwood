# frozen_string_literal: true

class Association
  def initialize(options)
    @attributes ||= options
    self
  end

  def attributes
    @attributes ||= {}
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
end
