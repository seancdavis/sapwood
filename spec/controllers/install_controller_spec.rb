require 'rails_helper'

describe InstallController do

  before(:each) { remove_config }
  after(:each) { remove_config }

  describe '#run' do
    it 'redirects no step to the current step' do
      get :run, :step => nil
      expect(response).to redirect_to(install_path(1))
    end
    it 'redirects the wrong step to the current step' do
      get :run, :step => 2
      expect(response).to redirect_to(install_path(1))
    end
  end

  describe '#next' do
    it 'bumps the current_step and redirects' do
      post :next, :step => 3 # step doesn't actually matter
      expect(response).to redirect_to(install_path(2))
    end
  end

end
