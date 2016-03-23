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
    content_tag(:div, :class => 'geocoder',
                :data => { :mapbox => mapbox_key }) do
      o = """
        <script src=\"https://api.mapbox.com/mapbox.js/v2.3.0/mapbox.js\">
        </script>
      """
      o += """
        <link href=\"https://api.mapbox.com/mapbox.js/v2.3.0/mapbox.css\"
              rel=\"stylesheet\">
      """
      o += form_obj.input name.to_sym, :as => :text, :required => false,
                          :input_html => { :class => 'geocode' }
      o.html_safe
    end
  end

end
