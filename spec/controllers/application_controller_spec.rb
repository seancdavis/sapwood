require 'rails_helper'

describe ApplicationController do

  describe '#home' do
    context 'when the app has not been installed' do
      after(:each) { remove_config }
      it 'redirects to install' do
        remove_config
        get :home
        expect(response).to redirect_to('/install/1')
      end
    end
    context 'when the app has been installed' do
      it 'redirects to sign in form' do
        Sapwood.set('installed?', true)
        Sapwood.write!
        get :home
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#auth' do
    before(:each) do
      @user = create(:user)
      @user.set_sign_in_key!
    end
    it 'returns 500 when key is missing' do
      expect { get :auth, :id => @user.id, :key => nil }
          .to raise_error(ActionController::UrlGenerationError)
    end
    it 'returns 404 when key is wrong' do
      expect { get :auth, :id => @user.id, :key => '123' }
          .to raise_error(ActionController::RoutingError)
    end
    it 'returns 404 when id is wrong' do
      expect { get :auth, :id => '123', :key => @user.sign_in_key }
          .to raise_error(ActionController::RoutingError)
    end
    it 'signs in when id and key match' do
      get :auth, :id => @user.id, :key => @user.sign_in_key
      expect(response).to redirect_to(root_path)
    end
  end

end
