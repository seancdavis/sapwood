require 'rails_helper'

describe InstallController do

  before(:each) { remove_config }
  after(:each) { remove_config }

  describe '#show' do
    it 'redirects no step to the current step' do
      get :show, :step => nil
      expect(response).to redirect_to(install_path(1))
    end
    it 'redirects the wrong step to the current step' do
      get :show, :step => 2
      expect(response).to redirect_to(install_path(1))
    end
    context 'when the app has been installed' do
      before(:each) do
        @admin = create(:admin)
        Sapwood.set('current_step', 7)
        Sapwood.set('installed?', true)
        Sapwood.write!
      end
      it 'redirects back to the root path' do
        get :show, :step => 2
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#update' do
    it 'bumps the current_step and redirects' do
      post :update, :step => 3 # step doesn't actually matter
      expect(response).to redirect_to(install_path(2))
    end
  end

end
