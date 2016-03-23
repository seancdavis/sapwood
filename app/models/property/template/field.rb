class Property::Template::Field

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

  def method_missing(method, *arguments, &block)
    return attributes[method.to_s] if respond_to?(method.to_s)
    super
  end

  def respond_to?(method, include_private = false)
    attributes.keys.include?(method.to_s)
  end

  # ---------------------------------------- Form Markup

  # TODO: Refactor all this nonsense into something more legible

  def content_tag(element, options = {}, &block)
    ActionController::Base.helpers.content_tag(element, options, &block)
  end

  def html(form_obj)
    return geocoded_html(form_obj) if type == 'geocode'
    form_obj.input name.to_sym, :required => false
  end

  def geocoded_html(form_obj)
    unless respond_to?(:mapbox_key)
      raise "mapbox_key missing from field: #{name}"
    end
    content_tag(:div, :class => 'geocoder') do
      o = form_obj.input name.to_sym, :as => :text, :required => false,
                        :input_html => { :class => 'geocode' }
      o += form_obj.input "#{name}_full_address".to_sym, :as => :hidden,
                          :input_html => { :class => 'full_address' }
      o += form_obj.input "#{name}_street_address".to_sym, :as => :hidden,
                          :input_html => { :class => 'street_address' }
      o += form_obj.input "#{name}_city".to_sym, :as => :hidden,
                          :input_html => { :class => 'city' }
      o += form_obj.input "#{name}_state".to_sym, :as => :hidden,
                          :input_html => { :class => 'state' }
      o += form_obj.input "#{name}_country_code".to_sym, :as => :hidden,
                          :input_html => { :class => 'country_code' }
      o += form_obj.input "#{name}_zip".to_sym, :as => :hidden,
                          :input_html => { :class => 'zip' }
      o += form_obj.input "#{name}_lat".to_sym, :as => :hidden,
                          :input_html => { :class => 'lat' }
      o += form_obj.input "#{name}_lng".to_sym, :as => :hidden,
                          :input_html => { :class => 'lng' }
    end
  end

end
