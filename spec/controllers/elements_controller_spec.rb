require 'rails_helper'

describe ElementsController do

  # ---------------------------------------- Index

  describe '#index' do
    context 'when template is a single_element' do
      before(:each) do
        @property = property_with_template_file('single_element')
        @user = create(:user)
        @user.properties << @property
        sign_in @user
      end
      it 'returns 200 when no elements' do
        get :index, params: { :property_id => @property.id, :template_id => 'default' }
        expect(response.status).to eq(200)
      end
      it 'redirects to edit form when one element' do
        el = create(:element, :property => @property)
        tmpl = @property.find_template('Default')
        get :index, params: { :property_id => @property.id, :template_id => 'default' }
        expect(response).to redirect_to([:edit, @property, tmpl, el])
      end
    end
    context 'for an unassigned property' do
      before(:each) { @property = property_with_templates }
      it 'returns 200 for an admin' do
        @user = create(:admin)
        sign_in @user
        get :index, params: { :property_id => @property.id, :template_id => '__all' }
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect {
          get :index, params: { :property_id => @property.id, :template_id => '__all' }
        }.to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an assigned property' do
      before(:each) { @property = property_with_templates }
      it 'returns 200 for a user' do
        @user = create(:user)
        @user.properties << @property
        sign_in @user
        get :index, params: { :property_id => @property.id, :template_id => '__all' }
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      before(:each) { @property = property_with_templates }
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect { get :index, params: { :property_id => '123', :template_id => '__all' } }
          .to raise_error(ActionController::RoutingError)
      end
    end
    context 'with templates' do
      before(:each) { @property = property_with_templates }
      before(:each) do
        @property.update(:templates_raw => File.read(template_config_file))
        @user = create(:user)
        @user.properties << @property
        sign_in @user
      end
      it 'returns 200 when template is found' do
        get :index, params: { :property_id => @property.id, :template_id => 'default' }
        expect(response.status).to eq(200)
      end
      it 'renders the index when one element' do
        el = create(:element, :property => @property)
        get :index, params: { :property_id => @property.id, :template_id => 'default' }
        expect(response.status).to eq(200)
      end
      it 'returns 404 when template is not found' do
        expect {
          get :index, params: { :property_id => @property.id, :template_id => 'wrong' }
        }.to raise_error(ActionController::RoutingError)
      end
      it 'redirects when the template is a document' do
        get :index, params: { :property_id => @property.id, :template_id => 'image' }
        expect(response).to redirect_to(
          property_template_documents_path(@property, 'image')
        )
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
        get :new, params: { :property_id => @property.id, :template_id => 'default' }
        expect(response.status).to eq(200)
      end
      it 'returns 404 for a user' do
        @user = create(:user)
        sign_in @user
        expect {
          get :new, params: { :property_id => @property.id, :template_id => 'default' }
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
        get :new, params: { :property_id => @property.id, :template_id => 'default' }
        expect(response.status).to eq(200)
      end
    end
    context 'for a non-existant property' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        sign_in @user
        expect {
          get :new, params: { :property_id => '123', :template_id => 'default' }
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
          get :edit, params: { :property_id => @property.id, :template_id => 'default',
              :id => @element.id }
          expect(response.status).to eq(200)
        end
        it 'returns 404 for a user' do
          @user = create(:user)
          sign_in @user
          expect {
            get :edit, params: { :property_id => @property.id, :template_id => 'default',
                :id => @element.id }
          }.to raise_error(ActionController::RoutingError)
        end
      end
      context 'for an assigned property' do
        it 'returns 200 for a user' do
          @user = create(:user)
          @user.properties << @property
          sign_in @user
          get :edit, params: { :property_id => @property.id, :template_id => 'default',
              :id => @element.id }
          expect(response.status).to eq(200)
        end
      end
      context 'for a non-existant property' do
        it 'returns 404 for an admin' do
          @user = create(:admin)
          sign_in @user
          expect {
            get :edit, params: { :property_id => '123', :template_id => 'default',
                :id => @element.id }
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
          get :edit, params: { :property_id => @property.id, :template_id => 'default',
              :id => '123' }
        }.to raise_error(ActionController::RoutingError)
      end
    end
    context 'for an non-existant element' do
      it 'returns 404 for an admin' do
        @user = create(:admin)
        @property = property_with_templates
        sign_in @user
        expect {
          get :edit, params: { :property_id => @property.id, :template_id => 'default',
              :id => 123123 }
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # ---------------------------------------- Create

  describe '#create' do
    before(:each) { @property = property_with_templates }
    it 'sends a notification for the appropriate property and users' do
      user = create(:admin)
      sign_in user
      # This one won't be triggered because we don't send it to the current
      # user.
      create(:notification, :property => @property, :user => user)
      # This one should be triggered.
      n_user = create(:admin)
      create(:notification, :property => @property, :user => (n_user))
      # This does not belong to the property.
      create(:notification, :user => user)
      # This does not belong to the user or the correct template.
      create(:notification, :property => @property, :user => user,
             :template_name => 'All Options')

      data = {
        :template_data => { :name => Faker::Lorem.words(4).join(' ') },
        :template_name => 'Default'
      }
      expect {
        post :create, params: { :property_id => @property.id, :template_id => 'Default',
             :element => data } }
        .to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(ActionMailer::Base.deliveries.last.to).to eq([n_user.email])
    end
    it 'goes back to the edit form when told so' do
      user = create(:admin)
      sign_in user
      data = {
        :template_data => { :name => (name = Faker::Lorem.words(4).join(' ')) },
        :template_name => 'Redirector'
      }
      post :create, params: { :property_id => @property.id, :template_id => 'Redirector',
           :element => data }
      el = Element.find_by_title(name)
      path = edit_property_template_element_path(@property, 'redirector', el)
      expect(request).to redirect_to(path)
    end
  end

end
