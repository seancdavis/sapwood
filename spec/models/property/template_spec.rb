require 'rails_helper'

describe Property::Template, :type => :model do

  let(:property) { create(:property) }

  before(:each) do
    file = File.expand_path('../../../support/template_config.json', __FILE__)
    @raw_templates = File.read(file)
    property.update!(:templates_raw => @raw_templates)
    @template = property.find_template('Default')
  end

  describe '#method_missing' do
    it 'has a title' do
      expect(@template.title).to eq('Default')
    end
  end

end