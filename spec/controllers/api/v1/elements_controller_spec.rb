require 'rails_helper'

describe Api::V1::ElementsController do

  before(:each) { @property = property_with_templates }

  # ---------------------------------------- Show

  describe '#show' do
    before(:each) do
      @element = create(:element, :with_options, :property => @property)
    end
    it 'raises 404 when no api_key' do
      expect {
        get :show, :id => @element, :format => :json
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when element does not belong to property' do
      element = create(:element, :with_options)
      expect {
        get :show, :id => element, :api_key => @property.api_key,
            :format => :json
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when api_key does not match property' do
      expect {
        get :show, :id => @element, :api_key => '123', :format => :json
      }.to raise_error(ActionController::RoutingError)
    end
    it 'responds with the element as json' do
      response = get :show, :id => @element, :api_key => @property.api_key,
                     :format => :json
      expect(response.body).to eq(@element.to_json)
    end
  end

  # ---------------------------------------- Index

  describe '#index' do
    before(:each) do
      create_list(:element, 5, :with_options, :property => @property)
    end
    it 'raises 404 when no api_key' do
      expect {
        get :index, :format => :json
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when api_key does not match a property' do
      expect {
        get :index, :api_key => '123', :format => :json
      }.to raise_error(ActionController::RoutingError)
    end
    it 'responds with the element as json' do
      response = get :index, :api_key => @property.api_key, :format => :json
      expect(response.body).to eq(@property.elements.to_json)
    end
  end

end
