# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController do

  describe '#auth' do
    before(:each) do
      @user = create(:user)
      @user.set_sign_in_key!
    end
    it 'returns 404 when key is wrong' do
      expect {
        get :auth, params: { user_id: @user.id, id: @user.sign_in_id, key: '123' }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'returns 404 when id is wrong' do
      expect {
        get :auth, params: { user_id: @user.id, id: '123', key: @user.sign_in_key }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'returns 404 when user id is wrong' do
      expect {
        get :auth, params: { user_id: '123', id: @user.sign_in_key,
            key: @user.sign_in_key }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'signs in when user id, id and key match' do
      get :auth, params: { user_id: @user.id, id: @user.sign_in_id,
          key: @user.sign_in_key }
      expect(response).to redirect_to(root_path)
    end
    it 'redirects if user is already signed in and creds are wrong' do
      sign_in @user
      get :auth, params: { user_id: @user.id, id: '123', key: '123' }
      expect(response).to redirect_to(root_path)
    end
  end

end
