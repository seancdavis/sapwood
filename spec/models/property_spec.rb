# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  labels        :json
#  templates_raw :text
#  forms_raw     :text
#

require 'rails_helper'

RSpec.describe Property, :type => :model do

  let(:property) { create(:property) }

  describe '#label' do
    Property.labels.each do |label|
      it "defaults to the titleized versions of itself for #{label}" do
        expect(property.label(label)).to eq(label.titleize)
      end
      it "will return a custom value for #{label}" do
        labels = {
          :elements => "Elements 123",
          :documents => "Documents 123",
          :collections => "Collections 123",
          :responses => "Responses 123"
        }
        property.update!(:labels => labels)
        expect(property.label(label)).to eq(labels[label.to_sym])
      end
    end
  end

  describe '#templates' do
    before(:each) do
      file = File.expand_path('../../support/template_config.json', __FILE__)
      @raw_templates = File.read(file)
    end
    it 'returns an empty array when there is no template' do
      expect(property.templates).to eq([])
    end
    it 'returns an error message when the JSON is malformed' do
      property.update!(:templates_raw => "#{@raw_templates}]]")
      expect { property.templates }.to raise_error(JSON::ParserError)
    end
    context 'when there are templates' do
      before(:each) { property.update!(:templates_raw => @raw_templates) }
      it 'returns an array' do
        expect(property.templates.class).to eq(Array)
      end
      it 'returns Property::Template objects within the array' do
        expect(property.templates.first.class).to eq(Property::Template)
      end
    end
  end

  describe '#find_template' do
    before(:each) do
      file = File.expand_path('../../support/template_config.json', __FILE__)
      @raw_templates = File.read(file)
      property.update!(:templates_raw => @raw_templates)
    end
    it 'can find a template by its title' do
      expect(property.find_template('Default').class).to eq(Property::Template)
    end
  end

end
