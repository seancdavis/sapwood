# frozen_string_literal: true

require 'rails_helper'

describe Api::ElementsController do

  let(:property) { property_with_templates }
  let(:api_key) { create(:key, property: property) }
  let(:other_api_key) { create(:key) }

  # ---------------------------------------- Index

  describe '#index' do
    let(:elements) { create_list(:element, 5, :with_options, property: property) }

    it 'raises a URL generation error when no property' do
      expect {
        get :index, params: { format: :json }
      }.to raise_error(ActionController::UrlGenerationError)
    end
    it 'raises 403 when no api_key' do
      expect {
        get :index, params: { property_id: property.id, format: :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 403 when api_key does not match a property' do
      expect {
        get :index, params: { property_id: property.id, api_key: other_api_key.value, format: :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'responds with the element as json' do
      response = get :index, params: { property_id: property.id, api_key: api_key.value, format: :json }
      expect(response.body).to eq(property.elements.by_title.to_json)
    end
    context 'when specifying template(s)' do
      it 'returns an empty array when template does not exist' do
        response = get :index, params: { property_id: property.id,
                       template: 'BLARGH', api_key: api_key.value,
                       format: :json }
        expect(response.body).to eq('[]')
      end
      it 'returns an array of elements when template exists' do
        # Create an element without the AllOptions template
        create(:element, property: property)
        response = get :index, params: { property_id: property.id,
                       template: 'AllOptions',
                       api_key: api_key.value, format: :json }
        elements = property.elements.with_template('AllOptions').by_title
        expect(response.body).to eq(elements.to_json)
      end
      it "can return multiple templates' elements at once" do
        create(:element, property: property)
        response = get :index, params: { property_id: property.id,
                       template: 'AllOptions,Default',
                       api_key: api_key.value, format: :json }
        elements = (
          property.elements.with_template('AllOptions') +
          property.elements.with_template('Default')
        ).sort_by(&:title)
        expect(response.body).to eq(elements.to_json)
      end
    end
    describe 'including associations' do
      before(:each) do
        @base_el = create(:element, property: property,
                          template_name: 'AllOptions')
        @els = []
        3.times do
          @els << create(:element, property: property,
                         template_name: 'More Options')
        end
        2.times do |idx|
          @els[idx].template_data_will_change!
          new_data = @els[idx].template_data.merge("option": @base_el.id.to_s)
          @els[idx].update(template_data: new_data)
        end
        # Now, only two of the three "More Options" elements have the
        # association. The other doesn't even have the key in template_data,
        # which helps us check against nil.
      end
      it 'does not include the association if not specified' do
        response = get :index, params: { property_id: property.id,
                       api_key: api_key.value, format: :json }
        el = JSON.parse(response.body).select { |e| e['id'] == @base_el.id }[0]
        expect(el['options']).to eq(nil)
      end
      it 'does not include the association if a template is not specified' do
        response = get :index, params: { property_id: property.id,
                       includes: 'options', api_key: api_key.value,
                       format: :json }
        el = JSON.parse(response.body).select { |e| e['id'] == @base_el.id }[0]
        expect(el['options']).to eq(nil)
      end
      it 'will include the association if specified with a template' do
        response = get :index, params: { property_id: property.id,
                       includes: 'options', template: 'AllOptions',
                       api_key: api_key.value, format: :json }
        el = JSON.parse(response.body).select { |e| e['id'] == @base_el.id }[0]
        els = [JSON.parse(@els[0].to_json), JSON.parse(@els[1].to_json)]
        expect(el['options']).to match_array(els)
      end
    end
    describe 'sorting/ordering' do
      it 'sorts by attribute, but defaults to ascending order' do
        create(:element, property: property)
        response = get :index, params: { property_id: property.id,
                       sort_by: 'comments', api_key: api_key.value,
                       format: :json }
        expect(response.body)
          .to eq(property.elements.by_field('comments', 'asc').to_json)
      end
      it 'sorts by attribute and direction when specified' do
        create(:element, property: property)
        response = get :index, params: { property_id: property.id,
                       sort_by: 'comments', sort_in: 'desc',
                       api_key: api_key.value, format: :json }
        expect(response.body)
          .to eq(property.elements.by_field('comments', 'desc').to_json)
      end
    end
  end

  # ---------------------------------------- Show

  describe '#show' do
    before(:each) do
      @element = create(:element, :with_options, property: property)
    end
    it 'raises a URL generation error when no property' do
      expect {
        get :show, params: { id: @element, format: :json }
      }.to raise_error(ActionController::UrlGenerationError)
    end
    it 'raises 404 when no api_key' do
      expect { get :show, params: { property_id: property.id, id: @element,
                   format: :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when element does not belong to property' do
      element = create(:element, :with_options)
      expect { get :show, params: { property_id: property.id, id: element,
                   api_key: api_key.value, format: :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when api_key does not match property' do
      expect { get :show, params: { property_id: property.id, id: @element,
                   api_key: other_api_key.value, format: :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'responds with the element as json' do
      response = get :show, params: { property_id: property.id, id: @element,
                     api_key: api_key.value, format: :json }
      expect(response.body).to eq(@element.to_json)
    end
    describe 'including associations' do
      before(:each) do
        @base_el = create(:element, property: property,
                          template_name: 'AllOptions')
        @els = []
        3.times do
          @els << create(:element, property: property,
                         template_name: 'More Options')
        end
        2.times do |idx|
          @els[idx].template_data_will_change!
          new_data = @els[idx].template_data.merge("option": @base_el.id.to_s)
          @els[idx].update(template_data: new_data)
        end
        # Now, only two of the three "More Options" elements have the
        # association. The other doesn't even have the key in template_data,
        # which helps us check against nil.
      end
      it 'does not include the association if not specified' do
        response = get :show, params: { property_id: property.id, id: @base_el.id,
                       api_key: api_key.value, format: :json }
        expect(JSON.parse(response.body)['options']).to eq(nil)
      end
      it 'will include the association if specified with a template' do
        response = get :show, params: { property_id: property.id, id: @base_el.id,
                       includes: 'options', template: 'AllOptions',
                       api_key: api_key.value, format: :json }
        els = [JSON.parse(@els[0].to_json), JSON.parse(@els[1].to_json)]
        expect(JSON.parse(response.body)['options']).to match_array(els)
      end
    end
  end

  # ---------------------------------------- Create

  describe '#create' do
    let(:writable_api_key) { create(:key, :writable, property: property) }

    it 'raises a URL generation error when no property' do
      expect {
        post :create, params: { format: :json }
      }.to raise_error(ActionController::UrlGenerationError)
    end
    it 'raises 404 when no api_key' do
      expect {
        post :create, params: { property_id: property.id, format: :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when api_key does not match property' do
      expect {
        post :create, params: { property_id: property.id, api_key: other_api_key.value,
             format: :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises 404 when template does not belong to site' do
      expect {
        post :create, params: { property_id: property.id,
             api_key: api_key.value,
             template: 'BAD TEMPLATE' }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'raises a 403 when the writable key does not have template access' do
      writable_api_key.update(template_names: ['Image'])
      expect {
        post(:create, params: {
          property_id: property.id,
          api_key: writable_api_key.value,

          name: Faker::Lorem.sentence,
          template: 'Default'
        })
      }.to raise_error(ActionController::RoutingError)
    end
    it 'will create an element and return the element as json' do
      expect(property.elements.count).to eq(0)
      name = Faker::Lorem.sentence
      response = post :create, params: {
        property_id: property.id,
        api_key: writable_api_key.value,

        name: name,
        template: 'Default'
      }
      expect(response.body).to eq(property.elements.first.to_json)
      expect(property.elements.count).to eq(1)
      expect(property.elements.first.title).to eq(name)
    end
    it 'will create a document element with a URL' do
      writable_api_key.update(template_names: ['Image'])
      expect(property.elements.count).to eq(0)
      name = Faker::Lorem.sentence
      response = post :create, params: {
        property_id: property.id,
        api_key: writable_api_key.value,

        name: name,
        template: 'Image',
        url: 'http://www.pdf995.com/samples/pdf.pdf'
      }
      expect(response.body).to eq(property.elements.first.to_json)
      expect(property.elements.count).to eq(1)
      el = property.elements.first
      expect(el.url.to_s).to eq('http://www.pdf995.com/samples/pdf.pdf')
    end
    it 'raises 403 if the key is not writable' do
      expect {
        post(:create, params: {
          property_id: property.id,
          api_key: api_key.value,

          name: Faker::Lorem.sentence,
          template: 'More Options'
        })
      }.to raise_error(ActionController::RoutingError)
    end
    it 'will raise 403 if template does not have create security enabled' do
      expect {
        post :create, params: { property_id: property.id,
             api_key: api_key.value,
             name: Faker::Lorem.sentence,
             template: 'Default' }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'will raise 403 if template specifies secret that is missing' do
      expect {
        post :create, params: { property_id: property.id,
             api_key: api_key.value,
             name: Faker::Lorem.sentence, template: 'AllOptions' }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'returns validation errors if there are any' do
      writable_api_key.update(template_names: ['AllOptions'])
      response = post :create, params: {
        property_id: property.id,
        api_key: writable_api_key.value,

        name1: 'BLAH BLAH',
        template: 'AllOptions'
      }
      expect(response.body).to eq({ "title": ["can't be blank"] }.to_json)
    end
    it 'sends a notification for the appropriate property and users' do
      user = create(:admin)
      # This one should be triggered.
      create(:notification, property: property, user: user)
      # This does not belong to the property.
      create(:notification, user: user)
      # This does not belong to the user or the correct template.
      create(:notification, property: property, user: user, template_name: 'AllOptions')

      writable_api_key.update(template_names: ['AllOptions'])

      expect {
        post(:create, params: {
          property_id: property.id,
          template: 'AllOptions',
          api_key: writable_api_key.value,
          name: (name = Faker::Lorem.sentence) })
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
    end
  end

  # ---------------------------------------- Generate URL

  describe '#generate_url' do
    let(:property) { property_with_template_file('private_docs') }

    it 'return 200 when everything is in place' do
      element = create(:element, :document, property: property,
                       template_name: 'Private')
      request = post :generate_url, params: {
        property_id: property.id, api_key: api_key.value, element_id: element.id, secret: 'abc123' }
      expect(request.body.starts_with?('http')).to eq(true)
    end
    it 'returns a 404 without an element id' do
      expect {
        post :generate_url, params: { property_id: property.id, secret: 'abc123',
             api_key: api_key.value, format: :json }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'return 404 when secret does not match' do
      element = create(:element, :document, property: property,
                       template_name: 'Private')
      expect {
        post :generate_url, params: { property_id: property.id,
             api_key: api_key.value,
             element_id: element.id, secret: 'abc1234' }
      }.to raise_error(ActionController::RoutingError)
    end
    it 'return 404 when there is no secret' do
      element = create(:element, :document, property: property,
                       template_name: 'Invalid')
      expect {
        post :generate_url, params: { property_id: property.id,
             api_key: api_key.value,
             element_id: element.id }
      }.to raise_error(ActionController::RoutingError)
    end
  end

end
