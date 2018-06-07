require 'rails_helper'

describe DocumentsController do

  # ---------------------------------------- Index

  describe '#index' do
    before(:each) { @property = property_with_templates }
    context 'for an unassigned property' do
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :index, params: { :property_id => @property.id, :template_id => 'image' }
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect {
          get :index, params: { :property_id => @property.id, :template_id => 'image' }
        }.to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :index, params: { :property_id => @property.id, :template_id => 'image' }
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :index, params: { :property_id => '123', :template_id => 'image' } }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- New

  describe '#index' do
    before(:each) { @property = property_with_templates }
    context 'for an unassigned property' do
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :new, params: { :property_id => @property.id, :template_id => 'image' }
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect {
          get :new, params: { :property_id => @property.id, :template_id => 'image' }
        }.to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :new, params: { :property_id => @property.id, :template_id => 'image' }
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :new, params: { :property_id => '123', :template_id => 'image' } }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

end
