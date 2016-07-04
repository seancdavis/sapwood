# == Schema Information
#
# Table name: properties
#
#  id                   :integer          not null, primary key
#  title                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  color                :string
#  labels               :json
#  templates_raw        :text
#  forms_raw            :text
#  hidden_labels        :text             default([]), is an Array
#  api_key              :string
#  collection_types_raw :text
#

require 'rails_helper'

RSpec.describe Property, :type => :model do

  let(:property) { create(:property) }

  describe '#generate_api_key' do
    it 'generates an api key on create' do
      p = create(:property, :api_key => nil)
      expect(p.api_key).to_not eq(nil)
    end
    it 'does not update the api key on update' do
      key = property.api_key
      property.update(:title => Faker::Company.bs)
      property.reload
      expect(property.api_key).to eq(key)
    end
  end

  describe '#set_default_collections' do
    it 'sets default collections when none are set' do
      expect(property.collection_types[0].title).to eq('Collection')
    end
  end

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
          :responses => "Responses 123",
          :users => "Users 123"
        }
        property.update!(:labels => labels)
        expect(property.label(label)).to eq(labels[label.to_sym])
      end
    end
  end

  describe '#hide_label' do
    let(:property) { create(:property, :with_labels) }
    it 'adds a label to the hidden labels array' do
      property.hide_label!('elements')
      expect(property.hidden_labels).to eq(%w(elements))
    end
  end

  describe '#unhide_label' do
    let(:property) { create(:property, :with_labels) }
    it 'removes a label to the hidden labels array' do
      property.hide_label!('elements')
      property.hide_label!('documents')
      property.unhide_label!('elements')
      expect(property.hidden_labels).to eq(%w(documents))
    end
  end

  describe '#label_hidden?' do
    let(:property) { create(:property, :with_labels) }
    it 'returns true when it has been added to the hidden_labels array' do
      property.hide_label!('elements')
      expect(property.label_hidden?('elements')).to eq(true)
    end
    it 'returns false when it has not been added to the hidden_labels array' do
      expect(property.label_hidden?('elements')).to eq(false)
    end
  end

  # ---------------------------------------- Templates

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

  describe '#valid_templates?' do
    before(:each) do
      file = File.expand_path('../../support/template_config.json', __FILE__)
      @raw_templates = File.read(file)
    end
    it 'returns true when there is no template' do
      expect(property.valid_templates?).to eq(true)
    end
    it 'returns an error message when the JSON is malformed' do
      property.update!(:templates_raw => "#{@raw_templates}]]")
      expect(property.valid_templates?).to eq(false)
    end
    it 'returns an array for valid JSON' do
      property.update!(:templates_raw => @raw_templates)
      expect(property.valid_templates?).to eq(true)
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

  # ---------------------------------------- Templates

  describe '#collection_types' do
    before(:each) do
      file = File
        .expand_path('../../support/collection_type_config.json', __FILE__)
      @config = File.read(file)
    end
    it 'returns an default collection when there is no collection_type' do
      expect(property.collection_types[0].title).to eq('Collection')
    end
    it 'returns an error message when the JSON is malformed' do
      property.update!(:collection_types_raw => "#{@config}]]")
      expect { property.collection_types }.to raise_error(JSON::ParserError)
    end
    context 'when there are collection types' do
      before(:each) { property.update!(:collection_types_raw => @config) }
      it 'returns an array' do
        expect(property.collection_types.class).to eq(Array)
      end
      it 'returns Property::CollectionType objects within the array' do
        expect(property.collection_types.first.class)
          .to eq(Property::CollectionType)
      end
    end
  end

  describe '#valid_collection_types?' do
    before(:each) do
      file = File
        .expand_path('../../support/collection_type_config.json', __FILE__)
      @config = File.read(file)
    end
    it 'returns true when there is no collection_type' do
      expect(property.valid_collection_types?).to eq(true)
    end
    it 'returns an error message when the JSON is malformed' do
      property.update!(:collection_types_raw => "#{@config}]]")
      expect(property.valid_collection_types?).to eq(false)
    end
    it 'returns an array for valid JSON' do
      property.update!(:collection_types_raw => @config)
      expect(property.valid_collection_types?).to eq(true)
    end
  end

  describe '#find_collection_type' do
    before(:each) do
      file = File
        .expand_path('../../support/collection_type_config.json', __FILE__)
      @config = File.read(file)
      property.update!(:collection_types_raw => @config)
    end
    it 'can find a collection_type by its title' do
      expect(property.find_collection_type('Default').class)
        .to eq(Property::CollectionType)
    end
  end

  # ---------------------------------------- Users

  describe '#users_with_access' do
    let(:property) { create(:property) }
    it 'always includes admins' do
      admins = create_list(:admin, 5)
      expect(property.users_with_access).to eq(admins)
    end
    it 'does not include non-admins who have not been added' do
      admin = create(:admin)
      create(:user)
      expect(property.users_with_access).to eq([admin])
    end
    it 'includes non-admins who have been added' do
      admin = create(:admin)
      user = create(:user)
      user.properties << property
      expect(property.users_with_access.include?(user)).to eq(true)
    end
  end

end
