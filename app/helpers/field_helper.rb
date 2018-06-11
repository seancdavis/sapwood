# frozen_string_literal: true

module FieldHelper
  def field_string_html(form_obj, field, object)
    form_obj.input field.name.to_sym, required: field.required?,
                   label: field.label, readonly: field.read_only?
  end

  def field_text_html(form_obj, field, object)
    form_obj.input field.name.to_sym, as: :text,
                   required: field.required?, label: field.label,
                   readonly: field.read_only?
  end

  def field_boolean_html(form_obj, field, object)
    form_obj.input field.name.to_sym, as: :boolean,
                   required: field.required?, label: field.label,
                   readonly: field.read_only?
  end

  def field_select_html(form_obj, field, object)
    form_obj.input field.name.to_sym, as: :select,
                   collection: field.options, required: field.required?,
                   label: field.label,
                   readonly: field.read_only?
  end

  def field_date_html(form_obj, field, object)
    form_obj.input field.name.to_sym, as: :string,
                   required: field.required?, label: field.label,
                   readonly: field.read_only?,
                   wrapper_html: { class: 'pickadate' },
                   input_html: { data: { format: field.format } }
  end

  def field_element_html(form_obj, field, object)
    if field.respond_to?(:templates) && field.templates.present? &&
       field.templates.size == 1 &&
      current_property.find_template(field.templates[0]).document?
      single_document_field(form_obj, field, object)
    else
      single_element_field(form_obj, field, object)
    end
  end

  def single_element_field(form_obj, field, object)
    elements = current_property.elements.by_title
    if field.respond_to?(:templates) && field.templates.present?
      elements = elements.where(template_name: field.templates)
    end
    form_obj.input field.name.to_sym, collection: elements,
                   required: field.required?, label: field.label,
                   readonly: field.read_only?
  end

  def single_document_field(form_obj, field, object)
    template = current_property.find_template(field.templates[0])
    path = new_property_template_document_path(current_property, template)
    document = object.send(field.name)
    content_tag(:div, class: 'input document-uploader',
                data: { uploader: path }) do
      o  = form_obj.input field.name.to_sym, as: :hidden,
                          required: field.required?,
                          readonly: field.read_only?
      o += content_tag(:label, field.label)
      if document.present?
<<<<<<< HEAD
        o += content_tag(:div, class: 'document-url') do
          link_to(document.url) do
            o2 = ''
            if document.public_document?
              o2 += image_tag(document.version(:xsmall, true))
=======
        o += content_tag(:div, :class => 'document-url') do
          link_to(document.url.to_s) do
            o2  = ''
            if document.public? && document.image?
              o2 += ix_image_tag(document.path, auto: 'format,compress', w: 100, h: 100, fit: 'crop', sizes: '50px')
            else
              o2 += image_tag('document.png')
>>>>>>> v3.0
            end
            o2 += content_tag(:span, document.title)
            o2 += content_tag(:a, 'REMOVE', href: '#', class: 'remove')
            o2.html_safe
          end
        end
      else
        o += content_tag(:div, class: 'document-url hidden') do
          link_to('#') do
            o2  = image_tag('')
            o2 += content_tag(:span, '')
          end
        end
      end
      o += link_to(
        'Choose Existing File',
        property_template_documents_path(current_property, template),
        class: 'document-chooser button'
      )
      o += link_to('Upload New File', '#', class: 'upload-trigger button')
      o.html_safe
    end
  end

  def field_elements_html(form_obj, field, object)
    if field.respond_to?(:templates) && field.templates.present? &&
       field.templates.size == 1 &&
      current_property.find_template(field.templates[0]).document?
      multi_documents_field(form_obj, field, object)
    else
      multi_element_field(form_obj, field, object)
    end
  end

  def multi_element_field(form_obj, field, object)
    content_tag(:div, class: "multiselect input #{field.name}") do
      o  = form_obj.input field.name.to_sym, as: :hidden,
                          required: field.required?,
                          readonly: field.read_only?
      o += content_tag(:label, field.label)
      elements = current_property.elements.by_title
      if field.respond_to?(:templates) && field.templates.present?
        elements = elements.where(template_name: field.templates)
      end
      o += content_tag(:select, class: 'select optional',
                       id: "multiselect_#{field.name}") do
        o2 = content_tag(:option, '', class: 'placeholder')
        elements.each do |el|
          next if el.template.blank?
          o2 += content_tag(:option, el.title, value: el.id, data: {
            url: edit_property_template_element_path(
              current_property, el.template, el
            )
          })
        end
        o2.html_safe
      end
      o += content_tag(:ul, class: 'selected-options') do
        o2 = ''
        object.send(field.name).each do |el|
          o2 += content_tag(:li, data: { id: el.id }) do
            o3  = link_to(el.title, [:edit, current_property, el.template, el],
                          target: '_blank')
            o3 += content_tag(:a, 'REMOVE', href: '#', class: 'remove')
            o3.html_safe
          end
        end
        o2.html_safe
      end
      o.html_safe
    end
  end

  def multi_documents_field(form_obj, field, object)
    template = current_property.find_template(field.templates[0])
    path = new_property_template_document_path(current_property, template,
                                               multipart: true)
    documents = object.send(field.name)
    content_tag(:div, class: 'input bulk-document-uploader',
                data: { uploader: path }) do
      o  = form_obj.input field.name.to_sym, as: :hidden,
                          required: field.required?,
                          readonly: field.read_only?
      o += content_tag(:label, field.label)
      o += content_tag(:div, nil, class: 'batch-uploader')
      o += content_tag(:ul, class: 'selected-documents') do
        o2 = ''
        documents.each do |document|
<<<<<<< HEAD
          o2 += content_tag(:li, class: 'document-url',
                            data: { id: document.id }) do
            o3 = document.p.thumb
            o3 += link_to(document.title, document.url, class: 'filename')
            o3 += content_tag(:a, 'REMOVE', href: '#', class: 'remove')
=======
          o2 += content_tag(:li, :class => 'document-url',
                            :data => { :id => document.id }) do
            o3 = image_tag(image_thumb_url(document))
            o3 += link_to(document.title, document.url.to_s, :class => 'filename')
            o3 += content_tag(:a, 'REMOVE', :href => '#', :class => 'remove')
>>>>>>> v3.0
            o3.html_safe
          end
        end
        o2.html_safe
      end
      o += content_tag(:li, nil, class: 'document-url hidden')
      o += link_to(
        'Choose Existing Files',
        property_template_documents_path(current_property, template),
        class: 'bulk-document-chooser button'
      )
      o += link_to('Upload New Files', '#', class: 'upload-trigger button')
      o.html_safe
    end
  end

  def field_wysiwyg_html(form_obj, field, object)
    form_obj.input field.name.to_sym, as: :text,
                   required: field.required?, label: field.label,
                   readonly: field.read_only?,
                   input_html: { class: 'wysiwyg' }
  end
end
