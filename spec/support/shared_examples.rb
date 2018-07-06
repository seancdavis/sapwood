# frozen_string_literal: true

RSpec.shared_examples 'request_requires_property_access' do |options = {}|
  it 'redirects visitors to sign in' do
    make_request
    if request.format == 'application/json'
      expect(response.status).to eq(401)
    else
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  it 'returns 404 when property does not exist' do
    sign_in(admin)
    expect { bad_request }.to raise_error(ActionController::RoutingError)
  end
  it 'returns 200 for admins' do
    sign_in(admin)
    make_request
    if options[:success_redirect].present?
      expect(response.status).to eq(302)
      expect(response.redirect_url).to_not eq(new_user_session_path)
    else
      expect(response.status).to eq(200)
    end
  end
  it 'returns 404 for users without access' do
    sign_in(user)
    expect { make_request }.to raise_error(ActionController::RoutingError)
  end
  it 'returns 200 for users with access' do
    sign_in(user)
    user.properties << property
    make_request
    if options[:success_redirect].present?
      expect(response.status).to eq(302)
      expect(response.redirect_url).to_not eq(new_user_session_path)
    else
      expect(response.status).to eq(200)
    end
  end
end
