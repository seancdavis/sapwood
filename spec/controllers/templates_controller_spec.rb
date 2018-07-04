# frozen_string_literal: true

require 'rails_helper'

describe TemplatesController do

  let(:property) { property_with_templates }
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:make_request) { get :index, params: { property_id: property.id } }

  # ---------------------------------------- Index

  describe '#index' do
    context '[visitor]' do
      it 'returns 404' do
        make_request
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context '[admin]' do
      it 'returns 404 when property does not exist' do
        sign_in(admin)
        expect { get :index, params: { property_id: 9999 } }
          .to raise_error(ActionController::RoutingError)
      end
      it 'redirects to property dash when no templates' do
        sign_in(admin)
        get :index, params: { property_id: (property = create(:property)).id }
        expect(response).to redirect_to(property)
      end
      it 'redirects to first template' do
        sign_in(admin)
        make_request
        expect(response).to redirect_to([property, property.templates.first, :elements])
      end
    end
    context '[user]' do
      it 'returns 404 when user does not have access' do
        sign_in(user)
        expect { make_request }.to raise_error(ActionController::RoutingError)
      end
      it 'redirects to property dash when no templates' do
        sign_in(user)
        property = create(:property)
        user.properties << property
        get :index, params: { property_id: property.id }
        expect(response).to redirect_to(property)
      end
      it 'redirects to first template' do
        sign_in(user)
        user.properties << property
        make_request
        expect(response).to redirect_to([property, property.templates.first, :elements])
      end
    end
  end

end
