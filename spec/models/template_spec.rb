require 'rails_helper'

describe Template, :type => :model do

  let(:property) { create(:property) }

  before(:each) do
    file = File.expand_path('../../support/template_config.json', __FILE__)
    @raw_templates = File.read(file)
    property.update!(:templates_raw => @raw_templates)
    @template = property.find_template('Default')
  end

  describe '#method_missing' do
    it 'has a title' do
      expect(@template.title).to eq('Default')
    end
  end

  describe '#webhook?' do
    it 'is true when it has the option' do
      expect(property.find_template('All Options').webhook?).to eq(true)
    end
    it 'is false when it does not have the option' do
      expect(property.find_template('Default').webhook?).to eq(false)
    end
  end

  describe '#slug' do
    it 'removes unwanted characters from title and returns' do
      template = property.find_template("-A & __ Fun(ny) - +Title^")
      expect(template.slug).to eq('a-fun-ny-title')
      expect(@template.slug).to eq('default')
    end
  end

  describe '#associations, #find_association' do
    it 'returns an empty array when no associations' do
      expect(@template.associations).to eq([])
    end
    it 'returns an array of associations otherwise' do
      template = property.find_template('all-options')
      expect(template.associations.class).to eq(Array)
      expect(template.associations[0].class).to eq(Association)
    end
    it 'can find an association when it exists' do
      template = property.find_template('all-options')
      expect(template.find_association('wrong')).to eq(nil)
      expect(template.find_association('options').class).to eq(Association)
    end
  end

  describe '#columns, #find_column' do
    it 'has a default set of columns' do
      expect(@template.find_column('name').class).to eq(Column)
      expect(@template.find_column('updated_at').class).to eq(Column)
    end
    it 'returns an array of columns otherwise' do
      template = property.find_template('all-options')
      expect(template.columns.class).to eq(Array)
      expect(template.columns[0].class).to eq(Column)
    end
    it 'has a default set of columns' do
    end
    it 'can find an column when it exists' do
      template = property.find_template('all-options')
      expect(template.find_column('wrong')).to eq(nil)
      expect(template.find_column('name').class).to eq(Column)
    end
  end

  describe '#fields, #find_field, #primary_field' do
    it 'returns an empty array when no fields' do
      template = property.find_template('a-fun-ny-title')
      expect(template.fields).to eq([])
    end
    it 'sets the first to primary when not specified' do
      expect(@template.find_field('name').primary?).to eq(true)
      expect(@template.primary_field.label).to eq('Name')
    end
    it 'returns an array of fields otherwise' do
      template = property.find_template('all-options')
      expect(template.fields.class).to eq(Array)
      expect(template.fields[0].class).to eq(Field)
    end
    it 'can find an field when it exists' do
      template = property.find_template('all-options')
      expect(template.find_field('wrong')).to eq(nil)
      expect(template.find_field('description').class).to eq(Field)
    end
  end

end
