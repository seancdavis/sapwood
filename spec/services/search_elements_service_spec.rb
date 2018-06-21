# frozen_string_literal: true

require 'rails_helper'

describe SearchElementsService do

  let(:property) { property_with_templates }

  def create_element(template_name)
    create(:element, property: property, template_name: template_name, template_data: { name: 'Hello World' })
  end

  let(:default_el) { create_element('Default') }
  let(:all_options_el) { create_element('AllOptions') }
  let(:more_options_el) { create_element('More Options') }
  let(:elements) { [default_el, all_options_el, more_options_el] }

  before(:each) { elements }

  it 'searches on title' do
    search_results = SearchElementsService.call(property: property, q: 'Hello World')
    expect(search_results).to match_array(elements)
  end

  it 'filters by template' do
    # "template" argument at beginning.
    search_results = SearchElementsService.call(property: property, q: 'template:Default Hello World')
    expect(search_results).to match_array([default_el])
    # "template" argument at end.
    search_results = SearchElementsService.call(property: property, q: 'Hello World template:Default')
    expect(search_results).to match_array([default_el])
  end

  it 'filters by multiple templates' do
    search_results = SearchElementsService.call(property: property, q: 'template:Default,AllOptions Hello World')
    expect(search_results).to match_array([default_el, all_options_el])
  end

end
