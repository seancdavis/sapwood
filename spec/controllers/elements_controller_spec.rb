# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  position      :integer          default(0)
#  body          :text
#  template_data :json             default({})
#  ancestry      :string
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe ElementsController do

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
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :new, :property_id => @property.id
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect { get :new, :property_id => @property.id }
          .to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :new, :property_id => @property.id
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :new, :property_id => '123' }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- Edit

  describe '#edit' do
    context 'for an existing element' do
      before(:each) do
        @property = create(:property)
        @element = create(:element, :property => @property)
      end
      context 'for an unassigned property' do
        it 'returns 200 for an admin' do
          @user = create(:admin)
          sign_in @user
          get :edit, :property_id => @property.id, :id => @element.id
          expect(response.status).to eq(200)
        end
        it 'returns 404 for a user' do
          @user = create(:user)
          sign_in @user
          expect { get :edit, :property_id => @property.id, :id => @element.id }
            .to raise_error(ActionController::RoutingError)
        end
      end
      context 'for an assigned property' do
        it 'returns 200 for a user' do
          @user = create(:user)
          @user.properties << @property
          sign_in @user
          get :edit, :property_id => @property.id, :id => @element.id
          expect(response.status).to eq(200)
        end
      end
      context 'for a non-existant property' do
        it 'returns 404 for an admin' do
          @user = create(:admin)
          sign_in @user
          expect { get :edit, :property_id => '123', :id => @element.id }
            .to raise_error(ActionController::RoutingError)
        end
      end
    end
    context 'for a non-existant element with a valid property' do
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
