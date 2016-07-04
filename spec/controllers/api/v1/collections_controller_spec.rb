require 'rails_helper'

describe Api::V1::CollectionsController do

  before(:each) do
    @property = create(:property)
  end

  describe '#index' do
    it 'raises 403 when no api_key' do
      expect { get :index }
        .to raise_error(ActionController::RoutingError)
    end
    it 'raises 403 when api_key does not match a property' do
      expect { get :index, :api_key => '123' }
        .to raise_error(ActionController::RoutingError)
    end
    it 'responds with the collections as json' do
      c_01 = create(:collection, :with_items, :property => @property)
      c_02 = create(:collection, :with_items, :property => @property)
      c_03 = create(:collection, :with_items)
      response = get :index, :api_key => @property.api_key,
                     :format => :json
      expect(response.body).to include(c_01.to_json)
      expect(response.body).to include(c_02.to_json)
      expect(response.body).to_not include(c_03.to_json)
    end
  end

  describe '#show' do
    it 'raises 403 when no api_key' do
      expect {
        get :show, :id => @property
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 403 when api_key does not match a property' do
      expect {
        get :show, :id => @property, :api_key => '123'
      }.to raise_error(ActionController::RoutingError)
    end
    it 'responds with the collection as json' do
      @collection = create(:collection, :with_items, :property => @property)
      response = get :show, :id => @collection, :api_key => @property.api_key,
                     :format => :json
      expect(response.body).to eq(@collection.to_json)
    end
  end

end
