# frozen_string_literal: true

require 'rails_helper'

describe Association, type: :model do

  before(:each) do
    @property = property_with_templates
    @template = @property.find_template('all-options')
    @association = @template.find_association('options')
  end

  describe '#name, #title' do
    it 'has a name and title' do
      expect(@association.name).to eq('options')
      expect(@association.title).to eq('options')
    end
  end

  # TODO: This should return a Field object.
  describe '#field' do
    it 'returns a field string' do
      expect(@association.field).to eq('option')
    end
  end

  # TODO: This should return a Template object.
  describe '#template' do
    it 'returns a template string' do
      expect(@association.template).to eq('More Options')
    end
  end

end
