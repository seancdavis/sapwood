require 'rails_helper'

describe DeckController do

  describe '#show' do
    context 'with no properties' do
      context 'as an admin' do
        it 'returns 200' do
          @user = create(:admin)
          sign_in @user
          get :show
          expect(response.status).to eq(200)
        end
      end
      context 'as an editor' do
        it 'returns 200' do
          @user = create(:user)
          sign_in @user
          get :show
          expect(response.status).to eq(200)
        end
      end
    end

    context 'with one property' do
      before(:each) { @property = create(:property) }
      context 'as an admin' do
        before(:each) do
          @user = create(:admin)
          sign_in @user
        end
        it 'returns 200' do
          get :show
          expect(response.status).to eq(200)
        end
      end
      context 'as an editor' do
        before(:each) do
          @user = create(:user)
          @user.properties << @property
          sign_in @user
        end
        it 'redirects to the property' do
          get :show
          expect(response).to redirect_to(property_path(@property))
        end
      end
    end

    context 'with two properties' do
      before(:each) do
        @property = create(:property)
        @second_property = create(:property)
      end
      context 'as an admin' do
        before(:each) do
          @user = create(:admin)
          sign_in @user
        end
        it 'returns 200' do
          get :show
          expect(response.status).to eq(200)
        end
      end
      context 'as an editor' do
        before(:each) do
          @user = create(:user)
          @user.properties << @property
          @user.properties << @second_property
          sign_in @user
        end
        it 'returns 200' do
          get :show
          expect(response.status).to eq(200)
        end
      end
    end
  end

end