# frozen_string_literal: true

require 'rails_helper'

describe AttachmentsController do

  let(:property) { property_with_templates }
  let(:attachment) { create(:attachment, property: property) }
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  # ---------------------------------------- Index

  describe '#index' do
    let(:make_request) { get :index, params: { property_id: property.id } }
    let(:bad_request) { get :index, params: { property_id: 0 } }

    it_behaves_like 'request_requires_property_access'
  end

  # ---------------------------------------- Index

  describe '#search' do
    let(:make_request) { get :search, params: { property_id: property.id, search: { q: 'hello' } } }
    let(:bad_request) { get :search, params: { property_id: property.id } }

    it_behaves_like 'request_requires_property_access'
  end

  # ---------------------------------------- | New

  describe '#new' do
    let(:make_request) { get :new, params: { property_id: property.id } }
    it 'does not exist' do
      expect { make_request }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  # ---------------------------------------- | Create

  describe '#create' do
    let(:url) { build(:attachment).url }
    let(:make_request) {
      post :create, params: { property_id: property.id, attachment: { url: url }, format: :json }
    }
    let(:bad_request) {
      post :create, params: { property_id: 0, attachment: { url: url }, format: :json }
    }

    it_behaves_like 'request_requires_property_access'
  end

  # ---------------------------------------- | Edit

  describe '#edit' do
    let(:make_request) { get :edit, params: { property_id: property.id, id: attachment.id } }
    let(:bad_request) { get :edit, params: { property_id: 0, id: attachment.id } }

    it_behaves_like 'request_requires_property_access'
  end

  # ---------------------------------------- | Create

  describe '#update' do
    let(:url) { build(:attachment).url }
    let(:make_request) {
      patch :update, params: { property_id: property.id, attachment: { url: url }, id: attachment.id }
    }
    let(:bad_request) {
      patch :update, params: { property_id: 0, attachment: { url: url }, id: attachment.id }
    }

    it_behaves_like 'request_requires_property_access', success_redirect: true
  end

  # ---------------------------------------- | Create

  describe '#destroy' do
    let(:make_request) { delete :destroy, params: { property_id: property.id, id: attachment.id } }
    let(:bad_request) { delete :destroy, params: { property_id: 0, id: attachment.id } }

    it_behaves_like 'request_requires_property_access', success_redirect: true
  end

end
