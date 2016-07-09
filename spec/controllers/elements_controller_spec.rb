# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  body          :text
#  template_data :json             default({})
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe ElementsController do

  # Note: We're using the "__all" override here for templates in every case,
  # since ommitting a template results in not found. There is one test for
  # valid/invalid template.

  # ---------------------------------------- Index

  describe '#index' do
    before(:each) { @property = create(:property) }
    context 'for an unassigned property' do
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :index, :property_id => @property.id, :template_id => '__all'
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect {
          get :index, :property_id => @property.id, :template_id => '__all'
        }.to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :index, :property_id => @property.id, :template_id => '__all'
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :index, :property_id => '123', :template_id => '__all' }
          .to raise_error(ActionController::RoutingError)
      end
    end
    context 'with templates' do
      before(:each) do
        @property.update(:templates_raw => File.read(template_config_file))
        @user = create(:admin)
        sign_in @user
      end
      it 'returns 200 when template is found' do
        get :index, :property_id => @property.id, :template_id => 'default'
        expect(response.status).to eq(200)
      end
      it 'returns 404 when template is not found' do
        expect {
          get :index, :property_id => @property.id, :template_id => 'wrong'
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- New

  describe '#new' do
    before(:each) do
      @property = create(:property,
                         :templates_raw => File.read(template_config_file))
    end
    context 'for an unassigned property' do
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :new, :property_id => @property.id, :template_id => 'default'
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect {
          get :new, :property_id => @property.id, :template_id => 'default'
        }.to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      before(:each) do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
      end
      it 'returns 200 for a user' do
        get :new, :property_id => @property.id, :template_id => 'default'
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect {
          get :new, :property_id => '123', :template_id => 'default'
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- Edit

  describe '#edit' do
    context 'for an existing element' do
      before(:each) do
        @property = create(:property,
                           :templates_raw => File.read(template_config_file))
        @element = create(:element, :property => @property)
      end
      context 'for an unassigned property' do
        it 'returns 200 for an admin' do
          @user = create(:admin)
          sign_in @user
          get :edit, :property_id => @property.id, :template_id => 'default',
              :id => @element.id
          expect(response.status).to eq(200)
        end
        it 'returns 404 for a user' do
          @user = create(:user)
          sign_in @user
          expect {
            get :edit, :property_id => @property.id, :template_id => 'default',
                :id => @element.id
          }.to raise_error(ActionController::RoutingError)
        end
      end
      context 'for an assigned property' do
        it 'returns 200 for a user' do
          @user = create(:user)
          @user.properties << @property
          sign_in @user
          get :edit, :property_id => @property.id, :template_id => 'default',
              :id => @element.id
          expect(response.status).to eq(200)
        end
      end
      context 'for a non-existant property' do
        it 'returns 404 for an admin' do
          @user = create(:admin)
          sign_in @user
          expect {
            get :edit, :property_id => '123', :template_id => 'default',
                :id => @element.id
          }.to raise_error(ActionController::RoutingError)
        end
      end
    end
    context 'for a non-existant element with a valid property' do
      it 'returns 404 for a user' do
        @property = create(:property)
        @user = create(:user)
        sign_in @user
        expect {
          get :edit, :property_id => @property.id, :template_id => 'default',
              :id => '123'
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

end
