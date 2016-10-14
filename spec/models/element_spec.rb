# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  template_data :json             default({})
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Element, :type => :model do

  before(:each) do
    @property = create(:property,
                       :templates_raw => File.read(template_config_file))
  end

  describe '#geocode_addresses' do
    context 'for a valid address' do
      before(:each) do
        @address = '1216 Central, 45202'
        @element = create(:element, :template_name => 'All Options',
                          :property => @property,
                          :template_data => { :address => @address })
      end
      it 'converts the value to a geocoded hash' do
        keys = %w(success lat lng country_code city state zip street_address
                  province district provider full_address is_us? ll precision
                  district_fips state_fips block_fips sub_premise raw)
        keys.each do |key|
          expect(@element.template_data['address'].keys).to include(key.to_sym)
        end
      end
      it 'returns a OpenStruct object when accessed through dynamic method' do
        expect(@element.address.class).to eq(OpenStruct)
      end
      it 'can access the original value via `raw' do
        expect(@element.address.raw).to eq(@address)
      end
      it 'can return latitude' do
        expect(@element.address.lat).to eq(39.1081586)
      end
      it 'can return longitude' do
        expect(@element.address.lng).to eq(-84.51938249999999)
      end
      it 'can return a lat/lng string' do
        expect(@element.address.ll).to eq('39.1081586,-84.51938249999999')
      end
      it 'can return the street address' do
        expect(@element.address.street_address).to eq('1216 Central Parkway')
      end
      it 'can return the state' do
        expect(@element.address.state).to eq('OH')
      end
      it 'can return the city' do
        expect(@element.address.city).to eq('Cincinnati')
      end
      it 'can return the country code' do
        expect(@element.address.country_code).to eq('US')
      end
      it 'can return the zip code' do
        expect(@element.address.zip).to eq('45202')
      end
    end
    context 'for an empty address' do
      before(:each) do
        @address = ''
        @element = create(:element, :template_name => 'All Options',
                          :property => @property,
                          :template_data => { :address => @address })
      end
      it 'returns a OpenStruct object when accessed through dynamic method' do
        expect(@element.address.class).to eq(OpenStruct)
      end
      it 'returns nil for `raw' do
        expect(@element.address.raw).to eq(nil)
      end
    end
    context 'for a missing address' do
      before(:each) do
        @element = create(:element, :template_name => 'All Options',
                          :property => @property)
      end
      it 'returns a OpenStruct object when accessed through dynamic method' do
        expect(@element.address.class).to eq(OpenStruct)
      end
      it 'returns nil for `raw' do
        expect(@element.address.raw).to eq(nil)
      end
    end
    context 'for an address that can not be geocoded' do
      before(:each) do
        @address = 'skjdhfwixmncask'
        @element = create(:element, :template_name => 'All Options',
                          :property => @property,
                          :template_data => { :address => @address })
      end
      it 'returns a OpenStruct object when accessed through dynamic method' do
        expect(@element.address.class).to eq(OpenStruct)
      end
      it 'returns an empty string for `raw' do
        expect(@element.address.raw).to eq('skjdhfwixmncask')
      end
    end
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
      field_names = %w{name description address image images many_things
                       comments one_thing}
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
      expect(@element.has_field?('address')).to eq(true)
    end
    it 'returns false for a field it does not have' do
      expect(@element.has_field?('abc')).to eq(false)
    end

    describe '#method_missing (dynamic field responses)' do
      before(:each) do
        @document = create(:document, :property => @property)
        @element = create(
          :element,
          :template_name => 'All Options',
          :property => @property,
          :template_data => {
            :description => 'This is a description',
            # :address => '1216 Central, 45202',
            :image => @document.id.to_s
          }
        )
      end
      it 'returns strings as strings' do
        expect(@element.description).to eq('This is a description')
      end
      # geocode responses are already tested above in #geocode_address
      it 'returns Document objects for document' do
        expect(@element.image).to eq(@document)
      end
      it 'returns nil when the document is missing' do
        element = create(:element, :template_name => 'All Options',
                         :property => @property)
        expect(element.image).to eq(nil)
      end
      it 'returns nil when the document does not exist' do
        element = create(:element, :template_name => 'All Options',
                         :property => @property,
                         :template_data => { :image => '123' })
        expect(element.image).to eq(nil)
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
    it 'has references to all necessary attributes' do
      # This is our element.
      element = create(:element, :with_options, :with_address,
                        :property => @property)
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
      documents = [create(:document, :property => @property),
                   create(:document, :property => @property)]
      element[:template_data]['images'] = documents.collect(&:id).join(',')
      # Save our element.
      element.save!

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
      expect(json[:address][:raw]).to eq('1216 Central Pkwy, 45202')
      # Document fields should return a document object.
      expect(json[:image][:url]).to eq(example_image_url)
      expect(json[:images].to_a).to match_array(documents)
      expect(json[:many_things].to_a).to match_array(many_things_els)
      # It includes an array of the specified association.
      expect(json[:options][0]).to eq(more_options_el)
      # And it also has its belongs_to element reference.
      expect(json[:one_thing]).to eq(one_thing_el)
    end
  end

end
