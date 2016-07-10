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

  describe '#has_webhook?' do
    it 'is true when it has the option' do
      expect(property.find_template('All Options').has_webhook?).to eq(true)
    end
    it 'is false when it does not have the option' do
      expect(property.find_template('Default').has_webhook?).to eq(false)
    end
  end

end
