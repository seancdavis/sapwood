require 'rails_helper'

describe Api::V1::ElementsController do

  before(:each) { @property = property_with_templates }

  # ---------------------------------------- Index

  describe '#index' do
    before(:each) do
      @elements = create_list(:element, 5, :with_options, :property => @property)
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
      expect(response.body).to eq(@property.elements.by_title.to_json)
    end
    context 'when specifying a template' do
      it 'returns an empty array when template does not exist' do
        response = get :index, :template => 'BLARGH',
                       :api_key => @property.api_key, :format => :json
        expect(response.body).to eq('[]')
      end
      it 'returns an empty array when template does not exist' do
        # Create an element without the All Options template
        create(:element, :property => @property)
        response = get :index, :template => 'All Options',
                       :api_key => @property.api_key, :format => :json
        expect(@property.elements.count).to eq(6)
        elements = @property.elements.with_template('All Options').by_title
        expect(response.body).to eq(elements.to_json)
      end
    end
    describe 'ordering' do
      it 'orders by attribute when told so' do
        create(:element, :property => @property)
        response = get :index, :order => 'comments',
                       :api_key => @property.api_key, :format => :json
        expect(response.body)
          .to eq(@property.elements.by_field('comments').to_json)
      end
      # Note: We've test responses without ordering above.
    end
  end

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

  # ---------------------------------------- Create

  describe '#create' do
    it 'raises 404 when no api_key' do
      expect {
        post :create, :property_id => @property.id, :format => :json
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when api_key does not match property' do
      expect {
        post :create, :property_id => @property.id, :api_key => '123',
             :format => :json
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when template does not belong to site' do
      expect {
        post :create, :property_id => @property.id,
             :api_key => @property.api_key, :format => :json,
             :template => 'BAD TEMPLATE'
      }.to raise_error(ActionController::RoutingError)
    end
    it 'will create an element and return the element as json' do
      expect(@property.elements.count).to eq(0)
      response = post :create, :property_id => @property.id,
                      :api_key => @property.api_key, :format => :json,
                      :name => (name = Faker::Lorem.words(4).join(' ')),
                      :template => 'Default'
      expect(response.body).to eq(@property.elements.first.to_json)
      expect(@property.elements.count).to eq(1)
      expect(@property.elements.first.title).to eq(name)
    end
    it 'returns validation errors if there are any' do
      response = post :create, :property_id => @property.id,
                      :api_key => @property.api_key, :format => :json,
                      :name1 => 'BLAH BLAH', :template => 'Default'
      expect(response.body)
        .to eq({"title": ["can't be blank", "can't be blank"]}.to_json)
    end
  end

end
