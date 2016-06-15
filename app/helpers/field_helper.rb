module FieldHelper

  def field_string_html(form_obj, options = {})
    form_obj.input options['name'].to_sym, :required => false
  end

  def field_document_html(form_obj, options = {})
    path = new_property_document_path(current_property)
    document = Document.find_by_id(form_obj.object.send(options['name']))
    content_tag(:div, :class => 'input document-uploader',
                :data => { :uploader => path }) do
      o  = form_obj.input options['name'].to_sym, :as => :hidden,
                          :required => false
      o += content_tag(:label, options['name'])
      if document.present?
        o += content_tag(:div, :class => 'document-url') do
          link_to(document.url) do
            o2  = ''
            o2 += image_tag(document.url) if document.image?
            o2 += content_tag(:span, document.title)
            o2.html_safe
          end
        end
      else
        o += content_tag(:div, :class => 'document-url hidden') do
          link_to('#') do
            o2  = image_tag('')
            o2 += content_tag(:span, '')
          end
        end
      end
      o += link_to("Choose Existing File", '#',
                   :class => 'document-chooser button')
      o += link_to("Upload New File", '#', :class => 'upload-trigger button')
      o.html_safe
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

  def field_wysiwyg_html(form_obj, options = {})
    form_obj.input options['name'].to_sym, :as => :text, :required => false,
                   :input_html => { :class => 'wysiwyg' }
  end

end
