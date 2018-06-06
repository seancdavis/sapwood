require 'rails_helper'

describe Api::V1::PropertiesController do

  before(:each) do
    @property = create(:property)
  end

  # NOTE: This also tests our base API connections, since everything is nested
  # under a property.

  describe '#show' do
    it 'raises 403 when no api_key' do
      expect {
        get :show, params: { :id => @property }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 403 when api_key does not match property' do
      expect {
        get :show, params: { :id => @property, :api_key => '123' }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'is authenticated when api_key matches property' do
      response = get :show, params: { :id => @property, :api_key => @property.api_key,
                     :format => :json }
      expect(response.status).to eq(200)
    end
    it 'responds with the property as json' do
      response = get :show, params: { :id => @property, :api_key => @property.api_key,
                     :format => :json }
      expect(response.body).to eq(@property.to_json)
    end
  end

end
