require 'rails_helper'

RSpec.describe Element, :type => :model do

  before(:each) do
    @property = create(:property,
                       :templates_raw => File.read(template_config_file))
  end

  describe '#template' do
    before(:each) do
      @element = create(:element, :template_name => 'All Options',
                        :property => @property)
    end
    it 'returns a Template object' do
      expect(@element.template.class).to eq(Template)
    end
  end

  describe '#template?' do
    it 'returns true when there is a template' do
      element = create(:element, :template_name => 'All Options',
                       :property => @property)
      expect(element.template?).to eq(true)
    end
    it 'returns false when the template does not exist' do
      element = create(:element, :template_name => 'A', :property => @property)
      expect(element.template?).to eq(false)
    end
  end

  describe '#field_names' do
    it 'returns an array of field names' do
      element = create(:element, :template_name => 'All Options',
                       :property => @property)
      field_names = %w{name description image images many_things
                       comments one_thing mixed_bag mixed_bags uneditable
                       complete date unformatted_date dropdown_menu}
      expect(element.field_names).to match_array(field_names)
    end
    it 'returns an empty array when the template does not exist' do
      element = create(:element, :template_name => 'A', :property => @property)
      expect(element.field_names).to eq([])
    end
  end

  describe '#has_field?' do
    before(:each) do
      @element = create(:element, :template_name => 'All Options',
                        :property => @property)
    end
    it 'returns true for a field it has' do
      expect(@element.has_field?('comments')).to eq(true)
    end
    it 'returns false for a field it does not have' do
      expect(@element.has_field?('abc')).to eq(false)
    end

    describe '#method_missing (dynamic field responses)' do
      before(:each) do
        @image = create(:element, :document, :property => @property)
        @images = create_list(:element, 3, :document, :property => @property)
        # Some other records we don't want to see
        create_list(:element, 5, :document, :property => @property)
        @element = create(
          :element,
          :template_name => 'All Options',
          :property => @property,
          :template_data => {
            :description => 'This is a description',
            :image => @image.id.to_s,
            :images => @images.collect(&:id).join(',')
          }
        )
      end
      it 'returns strings as strings' do
        expect(@element.description).to eq('This is a description')
      end
      it 'returns booleans as booleans' do
        # nil
        expect(@element.complete).to eq(false)
        # Set to "1" and test.
        @element.template_data = @element.template_data.merge(:complete => 1)
        @element.save
        expect(@element.reload.complete).to eq(true)
      end
      it 'returns Element objects for element fields' do
        expect(@element.image).to eq(@image)
      end
      it 'returns nil when the element is missing' do
        element = create(:element, :template_name => 'All Options',
                         :property => @property)
        expect(element.image).to eq(nil)
      end
      it 'returns nil when the element does not exist' do
        element = create(:element, :template_name => 'All Options',
                         :property => @property,
                         :template_data => { :image => '123' })
        expect(element.image).to eq(nil)
      end
      it 'returns Element objects for elements fields' do
        expect(@element.images).to match_array(@images)
      end
      it 'returns an empty array when the elements are missing' do
        element = create(:element, :template_name => 'All Options',
                         :property => @property)
        expect(element.images).to eq([])
      end
      it 'returns an empty array when the elements do not exist' do
        element = create(:element, :template_name => 'All Options',
                         :property => @property,
                         :template_data => { :images => '123' })
        expect(element.images).to eq([])
      end
      it 'returns elements in the saved order' do
        image_ids = @images.collect(&:id).shuffle.join(',')
        @element.template_data.merge!(:images => image_ids)
        @element.save
        image_ids = image_ids.split(',').map(&:to_i)
        3.times do |idx|
          expect(@element.reload.images[idx].id).to eq(image_ids[idx])
        end
      end
      it 'returns NoMethodError for fields that do not exist' do
        expect { @element.this_doesnt_exist }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#as_json' do
    it 'is still returned when the template does not exist' do
      el = create(:element, :property => @property, :template_name => 'NO!')
      expect(el.as_json.present?).to eq(true)
    end
    it 'skips bad attrs and fills in missing ones' do
      element = create(:element, :template_name => 'All Options',
                       :property => @property,
                       :template_data => {
                        'name' => 'Hello World', 'balls' => 'no_thanks' })
      expect(element.reload.template_data.keys).to include('comments')
      expect(element.reload.template_data.keys).to_not include('balls')
    end
    it 'has references to all necessary attributes' do
      # This is our element.
      element = create(:element, :with_options, :property => @property)
      element[:template_data]['complete'] = '1'
      # Create elements that we can use for associated records.
      more_options_el = create(:element, :property => @property,
                               :template_name => 'More Options')
      one_thing_el = create(:element, :property => @property,
                            :template_name => 'One Thing')
      many_things_els = create_list(:element, 3, :property => @property,
                                    :template_name => 'Many Things')
      # Add the implicit has_many
      more_options_el[:template_data]['option'] = element.id.to_s
      more_options_el.save!
      # Add the belongs_to.
      element[:template_data]['one_thing'] = one_thing_el.id.to_s
      # Add the has_many, including one that doesn't belong.
      bad_element = create(:element)
      element[:template_data]['many_things'] = (many_things_els + [bad_element])
        .collect(&:id).join(',')
      # Adding has_many documents
      documents = [create(:element, :document, :property => @property),
                   create(:element, :document, :property => @property)]
      element[:template_data]['images'] = documents.collect(&:id).join(',')
      # And our mixed bags.
      mixed_bag_el = create(:element, :property => @property,
                            :template_name => 'One Thing')
      element[:template_data]['mixed_bag'] = mixed_bag_el.id.to_s
      mixed_bag_els = [
        create(:element, :document, :property => @property),
        create(:element, :property => @property, :template_name => 'One Thing')
      ]
      element[:template_data]['mixed_bags'] = mixed_bag_els.collect(&:id).join(',')
      # Save our element.
      puts element.template_data
      element.save!
      puts element.template_data

      # Check JSON.
      json = element.as_json(:includes => 'options')
      expect(json[:id]).to eq(element.id)
      expect(json[:title]).to eq(element.title)
      expect(json[:slug]).to eq(element.slug)
      expect(json[:template_name]).to eq('All Options')
      expect(json[:created_at]).to eq(element.created_at)
      expect(json[:updated_at]).to eq(element.updated_at)
      # Custom template_data is brought to the top level.
      expect(json[:comments]).to eq(element.comments)
      expect(json[:complete]).to eq(true)
      # Document fields should return an element object.
      expect(json[:image][:url]).to eq(example_image_url)
      expect(json[:images].to_a).to match_array(documents)
      expect(json[:mixed_bag]).to eq(mixed_bag_el)
      expect(json[:mixed_bags].to_a).to match_array(mixed_bag_els)
      expect(json[:many_things].to_a).to match_array(many_things_els)
      # It includes an array of the specified association.
      expect(json[:options][0]).to eq(more_options_el)
      # It also has its belongs_to element reference.
      expect(json[:one_thing]).to eq(one_thing_el)
      # It doesn't have the document-specific fields.
      expect(json[:url]).to eq(nil)
      expect(json[:versions]).to eq(nil)
    end
  end

  # ---------------------------------------- Document Elements

  describe 'that acts as a document' do
    let(:document) {
      create(:element, :document, :from_system, :property => @property)
    }

    describe '#set_title' do
      it 'sets the title from the primary field if available' do
        expect(document.title).to eq(document.template_data['name'])
      end
      it 'sets the title from the filename if primary field is missing' do
        doc = create(:element, :document, :from_system, :property => @property,
                     :template_data => {})
        expect(doc.title).to eq('Example')
      end
      it 'does not set the title from the filename if primary field present' do
        doc = create(:element, :document, :from_system, :property => @property,
                     :template_data => { :name => 'Testing 123' })
        expect(doc.title).to eq('Testing 123')
      end
      it 'does not set the title if it already exists' do
        el = create(:element, :document, :title => 'Title')
        expect(el.title).to eq('Title')
      end
    end

    describe '#as_json' do
      it 'has a url reference' do
        expect(document.as_json({})[:url]).to eq(document.url)
      end
      it 'does not have versions if not processed' do
        expect(document.as_json({})[:versions]).to eq(nil)
      end
      it 'has a reference to versions if it is an image and processed' do
        json = document.as_json({})
        versions = %w{xsmall xsmall_crop small small_crop medium medium_crop
                      large large_crop xlarge xlarge_crop}
        expect(json[:versions].keys.map(&:to_s)).to match_array(versions)
      end
    end
  end

end
