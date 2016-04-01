# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  labels        :json
#  templates_raw :text
#  forms_raw     :text
#  hidden_labels :text             default([]), is an Array
#

require 'rails_helper'

describe PropertiesController do

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

  describe '#show' do
    before(:each) { @property = create(:property) }
    context 'for an unassigned property' do
      context 'as an admin' do
        before(:each) do
          @user = create(:admin)
          sign_in @user
        end
        it 'returns 200' do
          get :show, :id => @property.id
          expect(response.status).to eq(200)
        end
      end
      context 'as a user' do
        before(:each) do
          @user = create(:user)
          sign_in @user
        end
        it 'returns 404' do
          expect { get :show, :id => @property.id }
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
          get :show, :id => @property.id
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
          get :show, :id => @property.id
          expect(response.status).to eq(200)
        end
      end
      context 'as an admin' do
        before(:each) do
          @user = create(:admin)
          sign_in @user
        end
        it 'returns 404' do
          expect { get :show, :id => '123' }
            .to raise_error(ActionController::RoutingError)
        end
      end
    end
  end

  describe '#edit' do
    before(:each) { @property = create(:property) }
    context 'as an admin' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end
      it 'returns 200' do
        get :edit, :id => @property.id
        expect(response.status).to eq(200)
      end
    end
    context 'as a user (who has been assigned the property)' do
      before(:each) do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
      end
      it 'returns 404' do
        expect { get :edit, :id => @property.id }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

end
