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
    attributes['type']
  end

  def label
    attributes['label'] || attributes['name'].titleize
  end

  def title
    name
  end

  def is_document?
    type == 'document'
  end

  def method_missing(method, *arguments, &block)
    return attributes[method.to_s] if respond_to?(method.to_s)
    super
  end

  def respond_to?(method, include_private = false)
    attributes.keys.include?(method.to_s)
  end

  # ---------------------------------------- Form Markup

  # TODO: Refactor all this nonsense into something more legible

  # def content_tag(element, options = {}, &block)
  #   ActionController::Base.helpers.content_tag(element, options, &block)
  # end

  def html
    "field_#{type}_html"
    # return document_html(form_obj) if type == 'document'
    # return geocode_html(form_obj) if type == 'geocode'
    # form_obj.input name.to_sym, :required => false
  end

  def html_options
    attributes
  end

  def document_html(form_obj)
    content_tag(:div, :class => 'document-uploader') do
      form_obj.input "#{name}_id".to_sym, :required => false
    end
  end

end
