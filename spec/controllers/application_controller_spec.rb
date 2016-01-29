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
      it 'redirects to install' do
        Sapwood.set('installed?', true)
        Sapwood.write!
        get :home
        expect(response).to_not redirect_to('/install/1')
      end
    end
  end

end
