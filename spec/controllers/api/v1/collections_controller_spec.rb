require 'rails_helper'

describe Api::V1::CollectionsController do

  before(:each) do
    @property = property_with_templates
  end

  describe '#index' do
    it 'raises a URL generation error when no property' do
      expect { get :index }
        .to raise_error(ActionController::UrlGenerationError)
    end
    it 'raises 403 when no api_key' do
      expect { get :index, params: { :property_id => @property.id } }
        .to raise_error(ActionController::RoutingError)
    end
    it 'raises 403 when api_key does not match a property' do
      expect { get :index, params: { :property_id => @property.id, :api_key => '123' } }
        .to raise_error(ActionController::RoutingError)
    end
    context 'with collections' do
      before(:each) do
        @c_01 = create(:collection, :with_items, :property => @property)
        @c_02 = create(:collection, :with_items, :with_options,
                       :property => @property)
        @c_03 = create(:collection, :with_items, :with_options,
                       :property => property_with_templates)
      end
      it 'responds with all property ELEMENTS! as json' do
        response = get :index, params: { :property_id => @property.id,
                       :api_key => @property.api_key, :format => :json }
        @property.elements.each do |el|
          expect(response.body).to include(el.to_json)
        end
        expect(response.body).to_not include(@c_01.to_json)
        expect(response.body).to_not include(@c_02.to_json)
        expect(response.body).to_not include(@c_03.to_json)
      end
      it 'filters ELEMENTS! by type if specified' do
        good_el = create(:element, :property => @property,
                         :template_name => 'Default')
        bad_el = create(:element, :property => @property,
                        :template_name => 'All Options')
        response = get :index, params: { :property_id => @property.id,
                       :api_key => @property.api_key, :format => :json,
                       :type => 'Default' }
        expect(response.body).to include(good_el.to_json)
        expect(response.body).to_not include(bad_el.to_json)
        expect(response.body).to_not include(@c_01.to_json)
        expect(response.body).to_not include(@c_02.to_json)
        expect(response.body).to_not include(@c_03.to_json)
      end
      it 'returns no collections if the type does not exist' do
        response = get :index, params: { :property_id => @property.id,
                       :api_key => @property.api_key, :format => :json,
                       :type => 'WRONG! Collection' }
        expect(response.body).to eq('[]')
      end
    end
  end

  describe '#show' do
    before(:each) do
      @collection = create(:collection, :with_items, :property => @property)
    end
    it 'raises a URL generation error when no property' do
      expect { get :show }
        .to raise_error(ActionController::UrlGenerationError)
    end
    it 'raises 403 when no api_key' do
      expect {
        get :show, params: { :property_id => @property.id, :id => @collection }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 403 when api_key does not match a property' do
      expect { get :show, params: { :property_id => @property.id, :id => @collection,
                   :api_key => '123' }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'is not found when trying to access a collection' do
      expect { get :show, params: { :property_id => @property.id, :id => @collection,
                   :api_key => @property.api_key, :format => :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'responds with the MATCHING ELEMENT! as json' do
      el = create(:element, :property => @property)
      response = get :show, params: { :property_id => @property.id, :id => el,
                     :api_key => @property.api_key, :format => :json }
      expect(response.body).to eq(el.to_json)
    end
  end

end
