# frozen_string_literal: true

require 'rails_helper'

describe KeysController do

  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:property) { property_with_templates }

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

end
