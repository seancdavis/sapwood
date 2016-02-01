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
  end

  describe '#update' do
    it 'bumps the current_step and redirects' do
      post :update, :step => 3 # step doesn't actually matter
      expect(response).to redirect_to(install_path(2))
    end
  end

end
