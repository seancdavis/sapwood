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

  def path_method
    "property_template_#{document? ? 'documents' : 'elements'}_path"
  end

  def menu_label
    attributes['menu_label'] || name.pluralize
  end

  def type
    attributes['type'] || 'element'
  end

  def security
    (attributes['security'] || {}).to_ostruct
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
      "updated_at" => { "label" => "Last Modified", "format" => "%b %d, %Y" }
    }
  end

  def list
    attributes['list'] || {}
  end

  def columns
    columns = []
    (list['columns'] || default_columns).each do |field, attrs|
      f = if %w(updated_at created_at).include?(field)
        Field.new('name' => 'updated_at', 'type' => 'date')
      else
        find_field(field)
      end
      columns << Column.new(attrs.merge('field' => f))
    end
    columns
  end

  def find_column(name)
    columns.select { |f| f.field.name == name || f.label == name }.first
  end

  def fields
    return [] unless attributes['fields']
    fields = []
    if attributes['fields'].select { |n,d| d['primary'].to_bool }.blank?
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

  def geocode_fields
    fields.select { |f| f.type == 'geocode' }
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
