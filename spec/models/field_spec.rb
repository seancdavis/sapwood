require 'rails_helper'

describe Field, :type => :model do

  before(:each) do
    @property = property_with_templates
    @template = @property.find_template('all-options')
    @name = @template.find_field('name')
    @address = @template.find_field('address')
    @comments = @template.find_field('comments')
    @image = @template.find_field('image')
    @one_thing = @template.find_field('one_thing')
  end

  describe '#name. #title' do
    it 'has a name and title' do
      expect(@address.name).to eq('address')
      expect(@address.title).to eq('address')
    end
  end

  describe '#type, #document?, #element?, #date?' do
    it 'returns the type, and assumes string when not set' do
      expect(@name.type).to eq('string')
      expect(@address.type).to eq('geocode')
      expect(@image.type).to eq('element')
      expect(@comments.type).to eq('wysiwyg')
      expect(@one_thing.type).to eq('element')
    end
    it 'has boolean methods for certain fields' do
      expect(@name.document?).to eq(false)
      expect(@address.document?).to eq(false)
      # TODO: Eventually, we want this to return true.
      expect(@image.document?).to eq(false)
      expect(@comments.document?).to eq(false)
      expect(@one_thing.document?).to eq(false)

      expect(@name.element?).to eq(false)
      expect(@address.element?).to eq(false)
      # TODO: Eventually, we want this to return false.
      expect(@image.element?).to eq(true)
      expect(@comments.element?).to eq(false)
      expect(@one_thing.element?).to eq(true)

      expect(@name.date?).to eq(false)
      expect(@address.date?).to eq(false)
      expect(@image.date?).to eq(false)
      expect(@comments.date?).to eq(false)
      expect(@one_thing.date?).to eq(false)
    end
  end

  describe '#primary?' do
    it 'returns true for the primary field, and assumes the first otherwise' do
      expect(@name.primary?).to eq(true)
      expect(@address.primary?).to eq(false)
      expect(@image.primary?).to eq(false)
      expect(@comments.primary?).to eq(false)
      expect(@one_thing.primary?).to eq(false)
      expect(@property.find_template('default').find_field('name').primary?)
        .to eq(true)
    end
  end

  describe '#required?' do
    it 'returns true for the primary field and if set' do
      expect(@property.find_template('default').find_field('name').required?)
        .to eq(true)
      expect(
        @property.find_template('required').find_field('subtitle').required?
      ).to eq(true)
    end
  end

end
