# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  name                   :string
#  sign_in_key            :string
#

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

  # ---------------------------------------- Create

# expect { create(:task_with_assignee) }
        # .to change { ActionMailer::Base.deliveries.count }.by(2)
  describe '#create' do
    before(:each) do
      @property = create(:property)
      @admin = create(:admin)
      sign_in @admin
    end
    it 'sends a notification when creating a new user' do
      email = Faker::Internet.email
      expect {
        post :create, :property_id => @property.id, :user => { :email => email }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
    it 'does not send a notification when creating an existing user' do
      user = create(:user)
      email = user.email
      expect {
        post :create, :property_id => @property.id, :user => { :email => email }
      }.to change { ActionMailer::Base.deliveries.count }.by(0)
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
