require 'csv'

class ImportElements

  def initialize(options = {})
    @options = options
    required_args.each do |arg|
      raise "Missing required option: #{arg.to_s}" if @options[arg].blank?
    end
  end

  def self.call(options = {})
    new(options).call
  end

  def call
    elements = []
    CSV.parse(csv, :headers => true) do |row|
      attrs = {}
      element = property.elements.new(:template_name => template.name)
      row.to_hash.each do |attr, value|
        if template.find_field(attr).present?
          element.template_data = element.template_data.merge(attr => value)
        else
          element.send("#{attr}=", value)
        end
      end
      element.save!
      elements << element
    end
    elements
  end

  private

    def csv
      @csv ||= @options[:csv]
    end

    def property_id
      @property_id ||= @options[:property_id]
    end

    def property
      @property ||= Property.find_by_id(property_id)
    end

    def template_name
      @template_name ||= @options[:template_name]
    end

    def template
      @template ||= property.find_template(template_name)
    end

    def required_args
      [:csv, :template_name, :property_id]
    end

end
