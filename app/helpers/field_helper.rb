module FieldHelper

  def field_string_html(form_obj, options = {})
    form_obj.input options['name'].to_sym, :required => false
  end

  def field_document_html(form_obj, options = {})
    path = new_property_element_document_path(current_property, current_element)
    document = Document.find_by_id(form_obj.object.send(options['name']))
    content_tag(:div, :class => 'document-uploader',
                :data => { :uploader => path }) do
      o  = form_obj.input options['name'].to_sym, :as => :hidden,
                          :required => false
      o += link_to("Upload #{options['label']}", '#', :class => 'upload-trigger button')
      o += content_tag(:div, link_to(document.title, document.url),
                       :class => 'document-url') if document.present?
    end
  end

  def field_geocode_html(form_obj, options = {})
    value = if form_obj.object[options['name']].nil?
      nil
    else
      form_obj.object[options['name']]['raw']
    end
    content_tag(:div, :class => 'geocoder') do
      o = form_obj.input(
        options['name'].to_sym,
        :as => :text,
        :required => false,
        :input_html => { :class => 'geocode', :value => value }
      )
    end
  end

end
