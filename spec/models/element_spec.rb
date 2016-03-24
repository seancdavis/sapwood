# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  position      :integer          default(0)
#  body          :text
#  template_data :json             default({})
#  ancestry      :string
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Element, :type => :model do

  before(:all) do
    @property = create(:property, :templates_raw => File.read(template_config_file))
  end

  describe '#geocode_addresses' do
    context 'for a valid address' do
      before(:all) do
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
      before(:all) do
        @address = ''
        @element = create(:element, :template_name => 'All Options',
                          :property => @property,
                          :template_data => { :address => @address })
      end
      it 'returns a OpenStruct object when accessed through dynamic method' do
        expect(@element.address.class).to eq(OpenStruct)
      end
      it 'returns an empty string for `raw' do
        expect(@element.address.raw).to eq('')
      end
    end
    context 'for an address that can not be geocoded' do
      before(:all) do
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

end
