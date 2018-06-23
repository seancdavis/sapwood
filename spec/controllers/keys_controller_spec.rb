require 'rails_helper'

describe KeysController do

  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:property) { property_with_templates }

  let(:key) { create(:key, property: property) }

  # ---------------------------------------- | Index

  describe '#index' do
    context 'as an admin' do
      it 'returns 200' do
        sign_in admin
        get :index, params: { property_id: property.id }
        expect(response.status).to eq(200)
      end
    end
    context 'as a user' do
      it 'returns 404' do
        sign_in user
        expect {
          get :index, params: { property_id: property.id }
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- | New

  describe '#new' do
    context 'as an admin' do
      it 'returns 200' do
        sign_in admin
        get :new, params: { property_id: property.id }
        expect(response.status).to eq(200)
      end
    end
    context 'as a user' do
      it 'returns 404' do
        sign_in user
        expect {
          get :new, params: { property_id: property.id }
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- | Edit

  describe '#edit' do
    context 'as an admin' do
      it 'returns 200' do
        sign_in admin
        get :edit, params: { property_id: property.id, id: key.id }
        expect(response.status).to eq(200)
      end
      it 'returns 404 when the key belongs to a different property' do
        key = create(:key)
        sign_in admin
        expect {
          get :edit, params: { property_id: property.id, id: key.id }
        }.to raise_error(ActionController::RoutingError)
      end
    end
    context 'as a user' do
      it 'returns 404' do
        sign_in user
        expect {
          get :edit, params: { property_id: property.id, id: key.id }
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

end
