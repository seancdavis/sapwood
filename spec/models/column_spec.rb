require 'rails_helper'

describe Column, type: :model do

  before(:each) do
    @property = property_with_templates
    @template = @property.find_template('all-options')
    @description = @template.find_column('description')
    @name = @template.find_column('name')
    @updated_at = @template.find_column('updated_at')
  end

  describe '#field' do
    it 'returns a Field object' do
      expect(@description.field.class).to eq(Field)
    end
  end

  describe '#primary?' do
    it 'returns true if set' do
      expect(@description.primary?).to eq(false)
      expect(@name.primary?).to eq(true)
      expect(@updated_at.primary?).to eq(false)
    end
  end

  describe '#label' do
    it 'returns the set label or its field\'s label' do
      expect(@description.label).to eq('Description')
      expect(@name.label).to eq('Name')
      expect(@updated_at.label).to eq('Date Last Modified')
    end
  end

end
