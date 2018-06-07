require 'rails_helper'

describe Field, :type => :model do

  before(:each) do
    @property = property_with_templates
    @template = @property.find_template('all-options')
    @name = @template.find_field('name')
    @comments = @template.find_field('comments')
    @image = @template.find_field('image')
    @images = @template.find_field('images')
    @one_thing = @template.find_field('one_thing')
    @many_things = @template.find_field('many_things')
    @complete = @template.find_field('complete')

    @fields = [@name, @comments, @image, @images, @one_thing, @many_things, @complete]
  end

  describe '#type, #method_missing(?), #sendable?' do
    it 'returns the type, and assumes string when not set' do
      expect(@name.type).to eq('string')
      expect(@image.type).to eq('element')
      expect(@comments.type).to eq('wysiwyg')
      expect(@image.type).to eq('element')
      expect(@images.type).to eq('elements')
      expect(@one_thing.type).to eq('element')
      expect(@many_things.type).to eq('elements')
      expect(@complete.type).to eq('boolean')
    end
    it 'has boolean methods to check for field type' do
      expect(@name.string?).to eq(true)
      (@fields - [@name]).each { |f| expect(f.string?).to eq(false) }

      expect(@comments.wysiwyg?).to eq(true)
      (@fields - [@comments]).each { |f| expect(f.wysiwyg?).to eq(false) }

      expect(@complete.boolean?).to eq(true)
      (@fields - [@complete]).each { |f| expect(f.boolean?).to eq(false) }

      [@image, @one_thing].each { |f| expect(f.element?).to eq(true) }
      (@fields - [@image, @one_thing]).each do
        |f| expect(f.element?).to eq(false)
      end

      [@images, @many_things].each { |f| expect(f.elements?).to eq(true) }
      (@fields - [@images, @many_things]).each do
        |f| expect(f.elements?).to eq(false)
      end
    end
    it 'can determine whether to send the raw value or us method_missing' do
      [@name, @comments].each { |f| expect(f.sendable?).to eq(false) }
      (@fields - [@name, @comments]).each { |f| expect(f.sendable?).to eq(true) }
    end
  end

  describe '#primary?' do
    it 'returns true for the primary field, and assumes the first otherwise' do
      expect(@name.primary?).to eq(true)
      (@fields - [@name]).each { |f| expect(f.string?).to eq(false) }
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
