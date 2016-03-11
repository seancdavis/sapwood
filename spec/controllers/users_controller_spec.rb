require 'rails_helper'

describe UsersController do

  # ---------------------------------------- Index

  describe '#index' do
    before(:each) { @property = create(:property) }
    context 'for an unassigned property' do
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :index, :property_id => @property.id
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect { get :index, :property_id => @property.id }
          .to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :index, :property_id => @property.id
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :index, :property_id => '123' }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- New

  describe '#new' do
    before(:each) { @property = create(:property) }
    context 'for an unassigned property' do
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :new, :property_id => @property.id
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect { get :new, :property_id => @property.id }
          .to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :new, :property_id => @property.id
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :new, :property_id => '123' }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- Edit

  describe '#edit' do

    # Admins can view other admins in an existing property, but regular users
    # can not view admins.
    context 'admin users in an existing property' do
      before(:each) do
        @property = create(:property)
        @user = create(:admin)
      end
      it 'returns 200 for an admin' do
        user = create(:admin)
        sign_in user
        get :edit, :property_id => @property.id, :id => @user.id
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user without property access' do
        user = create(:user)
        sign_in user
        expect { get :edit, :property_id => @property.id, :id => @user.id }
          .to raise_error(ActionController::RoutingError)
      end
      it 'returns 404 for a user with property access' do
        user = create(:user)
        user.properties << @property
        sign_in user
        expect { get :edit, :property_id => @property.id, :id => @user.id }
          .to raise_error(ActionController::RoutingError)
      end
    end

    # No one (we're only checking admins) can view a user that doesn't exist.
    it 'returns 404 when the user does not exist' do
      property = create(:property)
      user = create(:admin)
      sign_in user
      expect { get :edit, :property_id => property.id, :id => '123' }
        .to raise_error(ActionController::RoutingError)
    end

    # No one (we're only checking admins) can view a valid user when the
    # property does not exist.
    it 'returns 404 when the property does not exist' do
      property = create(:property)
      user = create(:admin)
      sign_in user
      expect { get :edit, :property_id => '123', :id => user.id }
        .to raise_error(ActionController::RoutingError)
    end

    # Users with access can view a user that has property access.
    context 'user in an existing property with access to that property' do
      before(:each) do
        @property = create(:property)
        @user = create(:user)
        @user.properties << @property
      end
      it 'returns 200 for an admin' do
        user = create(:admin)
        sign_in user
        get :edit, :property_id => @property.id, :id => @user.id
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user without property access' do
        user = create(:user)
        sign_in user
        expect { get :edit, :property_id => @property.id, :id => @user.id }
          .to raise_error(ActionController::RoutingError)
      end
      it 'returns 200 for a user with property access' do
        user = create(:user)
        user.properties << @property
        sign_in user
        get :edit, :property_id => @property.id, :id => @user.id
        expect(response.status).to eq(200)
      end
    end

    # No one can view a user that does not have property access.
    context 'user in existing property with no access to that property' do
      before(:each) do
        @property = create(:property)
        @user = create(:user)
      end
      it 'returns 404 for an admin' do
        user = create(:admin)
        sign_in user
        expect { get :edit, :property_id => @property.id, :id => @user.id }
          .to raise_error(ActionController::RoutingError)
      end
      it 'returns 404 for a user without property access' do
        user = create(:user)
        sign_in user
        expect { get :edit, :property_id => @property.id, :id => @user.id }
          .to raise_error(ActionController::RoutingError)
      end
      it 'returns 404 for a user with property access' do
        user = create(:user)
        user.properties << @property
        sign_in user
        expect { get :edit, :property_id => @property.id, :id => @user.id }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end

end