require 'rails_helper'

describe PropertiesController do

  # ---------------------------------------- New

  describe '#new' do
    context 'as an admin' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end
      it 'returns 200' do
        get :new
        expect(response.status).to eq(200)
      end
    end
    context 'as a user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it 'returns 404' do
        expect { get :new }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- Show

  describe '#show' do
    before(:each) { @property = create(:property) }
    context 'for an unassigned property' do
      context 'as an admin' do
        before(:each) do
          @user = create(:admin)
          sign_in @user
        end
        it 'returns 200' do
          get :show, params: { :id => @property.id }
          expect(response.status).to eq(200)
        end
      end
      context 'as a user' do
        before(:each) do
          @user = create(:user)
          sign_in @user
        end
        it 'returns 404' do
          expect { get :show, params: { :id => @property.id } }
            .to raise_error(ActionController::RoutingError)
        end
      end
    end
    context 'for an assigned property' do
      context 'as a user' do
        before(:each) do
          @user = create(:user)
          @user.properties << @property
          sign_in @user
        end
        it 'returns 200' do
          get :show, params: { :id => @property.id }
          expect(response.status).to eq(200)
        end
      end
    end
    context 'for a non-existant property' do
      context 'as an admin' do
        before(:each) do
          @user = create(:admin)
          sign_in @user
        end
        it 'returns 200' do
          get :show, params: { :id => @property.id }
          expect(response.status).to eq(200)
        end
      end
      context 'as an admin' do
        before(:each) do
          @user = create(:admin)
          sign_in @user
        end
        it 'returns 404' do
          expect { get :show, params: { :id => '123' } }
            .to raise_error(ActionController::RoutingError)
        end
      end
    end
  end

  # ---------------------------------------- Edit

  describe '#edit' do
    before(:each) { @property = create(:property) }
    context 'as an admin' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end
      it 'returns 200 with a correct screen' do
        %w{general config keys}.each do |screen|
          get :edit, params: { :id => @property.id, :screen => screen }
          expect(response.status).to eq(200)
        end
      end
      it 'raises error without a screen' do
        expect { get :edit, params: { :id => @property.id } }
          .to raise_error(ActionController::UrlGenerationError)
      end
      it 'raises error with an incorrect screen' do
        expect { get :edit, params: { :id => @property.id, :screen => 'blah' } }
          .to raise_error(ActionController::RoutingError)
      end
    end
    context 'as a property admin' do
      it 'returns 200 with a correct screen' do
        @user = create(:user)
        @user.properties << @property
        @user.make_admin_in_properties!(@property)
        sign_in @user
        %w{general config keys}.each do |screen|
          get :edit, params: { :id => @property.id, :screen => screen }
          expect(response.status).to eq(200)
        end
      end
    end
    context 'as a user (who has been assigned the property)' do
      before(:each) do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
      end
      it 'returns 404' do
        %w{general config keys}.each do |screen|
          expect { get :edit, params: { :id => @property.id, :screen => screen } }
            .to raise_error(ActionController::RoutingError)
        end
      end
    end
  end

  # ---------------------------------------- Import

  describe '#import' do
    before(:each) { @property = create(:property) }
    it 'returns 200 as an admin' do
      user = create(:admin)
      sign_in user
      get :import, params: { :property_id => @property.id }
      expect(response.status).to eq(200)
    end
    it 'returns 404 as a user without acess' do
      user = create(:user)
      sign_in user
      expect { get :import, params: { :property_id => @property.id } }
        .to raise_error(ActionController::RoutingError)
    end
    it 'returns 200 for a property admin' do
      user = create(:user)
      user.properties << @property
      user.make_admin_in_properties!(@property)
      sign_in user
      get :import, params: { :property_id => @property.id }
      expect(response.status).to eq(200)
    end
    it 'returns 404 as a property user' do
      user = create(:user)
      user.properties << @property
      sign_in user
      expect { get :import, params: { :property_id => @property.id } }
        .to raise_error(ActionController::RoutingError)
    end
  end

end
