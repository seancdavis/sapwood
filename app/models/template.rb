# frozen_string_literal: true

class Template
  def initialize(options = {})
    @attributes ||= options
    self
  end

  def attributes
    @attributes ||= {}
  end

  def name
    title
  end

  def slug
    @slug ||= title.gsub(/[^0-9a-z-]/i, '-').gsub(/-+/, '-').gsub(/-$/, '')
      .gsub(/^-/, '').downcase
  end

  def to_param
    slug
  end

  def to_model
    Template.new(attributes)
  end

  def model_name
    ActiveModel::Name.new(Template)
  end

  def webhook?
    attributes['webhook_url'].present?
  end

  def document?
    respond_to?(:type) && type == 'document'
  end

  def aws_acl
    private? ? 'private' : 'public-read'
  end

  def private?
    security.try(:private).to_bool
  end

  def public?
    !private?
  end

  def path_method
    "property_template_#{document? ? 'documents' : 'elements'}_path"
  end

  def menu_label
    attributes['menu_label'] || name.pluralize
  end

  def type
    attributes['type'] || 'element'
  end

  def hidden?
    attributes['hidden'] || false
  end

  def security
    (attributes['security'] || {}).to_ostruct
  end

  def redirect_after_save?
    return true if attributes['after_save'].nil?
    return true if attributes['after_save']['redirect'].nil?
    attributes['after_save']['redirect'].to_bool
  end

  def page_length
    attributes['page_length'] || 20
  end

  def associations
    return [] unless attributes['associations']
    associations = []
    attributes['associations'].each do |name, data|
      associations << Association.new(data.merge('name' => name))
    end
    associations
  end

  def find_association(name)
    associations.select { |f| f.name == name }.first
  end

  def default_columns
    {
      primary_field.name => primary_field.attributes,
      'updated_at' => { 'label' => 'Last Modified', 'format' => '%b %d, %Y' }
    }
  end

  def list
    attributes['list'] || {}
  end

  def columns
    columns = []
    (list['columns'] || default_columns).each do |name, attrs|
      f = if %w(updated_at created_at).include?(name)
        Field.new('name' => 'updated_at', 'type' => 'date')
      else
        find_field(attrs['field']) || find_field(name)
      end
      # TODO: We don't need to give feedback here, but this should be caught
      # when the config checker utility is added.
      next if f.blank?
      columns << Column.new(attrs.merge('name' => name, 'field' => f))
    end
    columns[0].attributes['primary'] = true if columns.select(&:primary?).blank?
    columns
  end

  def find_column(name)
    columns.select { |f| f.field.name == name || f.label == name }.first
  end

  def fields
    return [] unless attributes['fields']
    fields = []
    if attributes['fields'].select { |n, d| d['primary'].to_bool }.blank?
      attributes['fields'][attributes['fields'].keys[0]]['primary'] = true
    end
    attributes['fields'].each do |name, data|
      fields << Field.new(data.merge('name' => name))
    end
    fields
  end

  def find_field(name)
    fields.select { |f| f.name == name }.first
  end

  def primary_field
    fields.select(&:primary?).first
  end

  def method_missing(method, *arguments, &block)
    return attributes[method.to_s] if respond_to?(method.to_s)
    return {} if method.to_s == 'fields'
    super
  end

  def respond_to?(method, include_private = false)
    (attributes.keys + ['namespace']).include?(method.to_s)
  end
end
