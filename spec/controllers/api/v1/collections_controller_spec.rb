require 'rails_helper'

describe Api::V1::CollectionsController do

  before(:each) do
    @property = create(:property)
    @collection = create(:collection, :with_items, :property => @property)
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
      response = get :show, :id => @collection, :api_key => @property.api_key,
                     :format => :json
      expect(response.body).to eq(@collection.to_json)
    end
  end

end
