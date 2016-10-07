module FieldHelper

  def field_string_html(form_obj, field, object)
    form_obj.input field.name.to_sym, :required => field.required?
  end

  def field_text_html(form_obj, field, object)
    form_obj.input field.name.to_sym, :as => :text, :required => field.required?
  end

  def field_document_html(form_obj, field, object)
    path = new_property_document_path(current_property)
    document = object.send(field.name)
    content_tag(:div, :class => 'input document-uploader',
                :data => { :uploader => path }) do
      o  = form_obj.input field.name.to_sym, :as => :hidden,
                          :required => field.required?
      o += content_tag(:label, field.name)
      if document.present?
        o += content_tag(:div, :class => 'document-url') do
          link_to(document.url) do
            o2  = ''
            o2 += image_tag(document.version(:xsmall, true)) if document.image?
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

  def field_documents_html(form_obj, field, object)
    path = new_property_document_path(current_property, :multipart => true)
    documents = object.send(field.name)
    content_tag(:div, :class => 'input bulk-document-uploader',
                :data => { :uploader => path }) do
      o  = form_obj.input field.name.to_sym, :as => :hidden,
                          :required => field.required?
      o += content_tag(:label, field.name)
      o += content_tag(:div, nil, :class => 'batch-uploader')
      documents.each do |document|
        o += content_tag(:div, :class => 'document-url') do
          link_to(document.url) do
            o2  = ''
            o2 += document.p.thumb
            o2 += content_tag(:span, document.title)
            o2.html_safe
          end
        end
      end
      o += content_tag(:div, nil, :class => 'document-url hidden')
      o += link_to("Choose Existing Files", '#',
                   :class => 'bulk-document-chooser button')
      o += link_to("Upload New Files", '#', :class => 'upload-trigger button')
      o.html_safe
    end
  end

  def field_geocode_html(form_obj, field, object)
    value = if form_obj.object[field.name].nil?
      nil
    else
      form_obj.object[field.name]['raw']
    end
    content_tag(:div, :class => 'geocoder') do
      o = form_obj.input(
        field.name.to_sym,
        :as => :text,
        :required => field.required?,
        :input_html => { :class => 'geocode', :value => value }
      )
    end
  end

  def field_element_html(form_obj, field, object)
    elements = current_property.elements.by_title
    if field.respond_to?(:templates) && field.templates.present?
      elements = elements.where(:template_name => field.templates)
    end
    form_obj.input field.name.to_sym, :collection => elements,
                   :required => field.required?
  end

  def field_elements_html(form_obj, field, object)
    content_tag(:div, :class => 'multiselect input') do
      o  = form_obj.input field.name.to_sym, :as => :hidden,
                          :required => field.required?
      o += content_tag(:label, field.name)
      elements = current_property.elements.by_title
      if field.respond_to?(:templates) && field.templates.present?
        elements = elements.where(:template_name => field.templates)
      end
      o += content_tag(:select, :class => 'select optional',
                       :id => "multiselect_#{field.name}") do
        o2 = content_tag(:option, '', :class => 'placeholder')
        elements.each do |el|
          o2 += content_tag(:option, el.title, :value => el.id)
        end
        o2.html_safe
      end
      o += content_tag(:ul, :class => 'selected-options') do
        o2 = ''
        object.send(field.name).each do |el|
          o2 += content_tag(:li, :data => { :id => el.id }) do
            o3  = content_tag(:span, el.title)
            o3 += content_tag(:a, 'REMOVE', :href => '#', :class => 'remove')
            o3.html_safe
          end
        end
        o2.html_safe
      end
      o.html_safe
    end
  end

  def field_wysiwyg_html(form_obj, field, object)
    form_obj.input field.name.to_sym, :as => :text,
                   :required => field.required?,
                   :input_html => { :class => 'wysiwyg' }
  end

end
