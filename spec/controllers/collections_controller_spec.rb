# == Schema Information
#
# Table name: collections
#
#  id                   :integer          not null, primary key
#  title                :string
#  property_id          :integer
#  item_data            :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  collection_type_name :string
#  field_data           :json             default({})
#

require 'rails_helper'

describe CollectionsController do

  # ---------------------------------------- Index

  describe '#index' do
    before(:each) { @property = create(:property) }
    context 'for an unassigned property' do
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :index, :property_id => @property.id
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect { get :index, :property_id => @property.id }
          .to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :index, :property_id => @property.id
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :index, :property_id => '123' }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- New

  describe '#new' do
    before(:each) { @property = create(:property) }
    context 'for an unassigned property' do
      it 'returns 404 for an admin when no collection_type is specified' do
        @user = create(:admin)
        sign_in @user
        expect { get :new, :property_id => @property.id }
          .to raise_error(ActionController::RoutingError)
      end
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :new, :property_id => @property.id, :collection_type => 'Collection'
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect { get :new, :property_id => @property.id,
                     :collection_type => 'Collection' }
          .to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :new, :property_id => @property.id, :collection_type => 'Collection'
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :new, :property_id => '123',
                     :collection_type => 'Collection' }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- Edit

  describe '#edit' do
    context 'for an existing collection' do
      before(:each) do
        @property = create(:property)
        @collection = create(:collection, :property => @property)
      end
      context 'for an unassigned property' do
        it 'returns 200 for an admin' do
          @user = create(:admin)
          sign_in @user
          get :edit, :property_id => @property.id, :id => @collection.id
          expect(response.status).to eq(200)
        end
        it 'returns 404 for a user' do
          @user = create(:user)
          sign_in @user
          expect {
            get :edit, :property_id => @property.id, :id => @collection.id
          }.to raise_error(ActionController::RoutingError)
        end
      end
      context 'for an assigned property' do
        it 'returns 200 for a user' do
          @user = create(:user)
          @user.properties << @property
          sign_in @user
          get :edit, :property_id => @property.id, :id => @collection.id
          expect(response.status).to eq(200)
        end
      end
      context 'for a non-existant property' do
        it 'returns 404 for an admin' do
          @user = create(:admin)
          sign_in @user
          expect { get :edit, :property_id => '123', :id => @collection.id }
            .to raise_error(ActionController::RoutingError)
        end
      end
    end
    context 'for a non-existant collection with a valid property' do
      it 'returns 404 for a user' do
        @property = create(:property)
        @user = create(:user)
        sign_in @user
        expect { get :edit, :property_id => @property.id, :id => '123' }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

end
