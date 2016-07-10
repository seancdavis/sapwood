require 'rails_helper'

describe CollectionType, :type => :model do

  let(:property) { create(:property) }

  before(:each) do
    file = File
      .expand_path('../../support/collection_type_config.json', __FILE__)
    @config = File.read(file)
    property.update!(:collection_types_raw => @config)
    @collection_type = property.find_collection_type('Default Collection')
  end

  describe '#method_missing' do
    it 'has a title' do
      expect(@collection_type.title).to eq('Default Collection')
    end
  end

end
