# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Property, type: :model do

  let(:property) { create(:property) }

  # ---------------------------------------- Views

  describe '[views]' do
    it 'creates a "Recent" view when a property is created' do
      view = property.views.first
      expect(view.title).to eq('Recent')
      expect(view.q).to eq(nil)
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
    context 'when there are templates' do
      before(:each) { property.update!(templates_raw: @raw_templates) }
      it 'returns an array' do
        expect(property.templates.class).to eq(Array)
      end
      it 'returns Template objects within the array' do
        expect(property.templates.first.class).to eq(Template)
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
      property.update!(templates_raw: "#{@raw_templates}]]")
      expect(property.valid_templates?).to eq(false)
    end
    it 'returns an array for valid JSON' do
      property.update!(templates_raw: @raw_templates)
      expect(property.valid_templates?).to eq(true)
    end
  end

  describe '#find_template' do
    before(:each) do
      file = File.expand_path('../../support/template_config.json', __FILE__)
      @raw_templates = File.read(file)
      property.update!(templates_raw: @raw_templates)
    end
    it 'can find a template by its title' do
      expect(property.find_template('Default').class).to eq(Template)
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
