# frozen_string_literal: true

require 'rails_helper'

describe SearchElementsService do

  let(:property) { property_with_templates }
  let(:elements) { property.elements }

  def create_element(template_name, name)
    create(:element, property: property, template_name: template_name, template_data: { name: name })
  end

  # ---------------------------------------- | Title Searching

  context '[Text Searching]' do
    %w{Pick Picking Picker Picnic}.each do |title|
      let("#{title.downcase}_el".to_sym) { create_element('Default', title) }
    end
    let(:elements) { [pick_el, picking_el, picker_el, picnic_el] }

    before(:each) { elements }

    it 'searches on title' do
      res = SearchElementsService.call(property: property, q: 'Picnic')
      expect(res).to match_array([picnic_el])
    end

    it 'is case-insensitive' do
      res = SearchElementsService.call(property: property, q: 'picnic')
      expect(res).to match_array([picnic_el])
    end

    it 'supports stemming' do
      res = SearchElementsService.call(property: property, q: 'pick')
      expect(res).to match_array([pick_el, picking_el, picker_el])
    end

    it 'returns all elements when q is nil' do
      res = SearchElementsService.call(property: property)
      expect(res).to match_array(elements)
    end
  end

  # ---------------------------------------- | Sorting

  context '[Sorting]' do
    %w{a b c d}.each do |desc|
      let("#{desc.downcase}_el".to_sym) do
        create(:element, property: property, template_name: 'All Options', template_data: { name: Faker::Book.title, description: desc })
      end
    end
    let(:elements) { [b_el, d_el, a_el, c_el] }

    before(:each) { elements }

    it 'can sort by a field' do
      res = SearchElementsService.call(property: property, q: 'template:all-options sort:description')
      expect(res).to eq(elements.sort_by(&:description))
    end

    it 'can sort in descending order' do
      res = SearchElementsService.call(property: property, q: 'template:all-options sort:description,desc')
      expect(res).to eq(elements.sort_by(&:description).reverse)
    end

    it 'ignores fields that do not exist' do
      res = SearchElementsService.call(property: property, q: 'template:all-options sort:blahblah')
      expect(res).to eq(elements.sort_by(&:id))
    end

    it 'sorts by updated_at/desc by default' do
      res = SearchElementsService.call(property: property, q: 'template:all-options')
      expect(res).to eq(elements.sort_by(&:updated_at).reverse)
    end
  end

  # ---------------------------------------- | Template Filtering

  context '[Template Filtering]' do
    let(:default_el) { create_element('Default', 'Hello World') }
    let(:all_options_el) { create_element('All Options', 'Hello World') }
    let(:child_el) { create_element('Child', 'Hello World') }
    let(:elements) { [default_el, all_options_el, child_el] }

    before(:each) { elements }

    it 'filters by template' do
      # "template" argument at beginning.
      res = SearchElementsService.call(property: property, q: 'template:Default Hello World')
      expect(res).to match_array([default_el])
      # "template" argument at end.
      res = SearchElementsService.call(property: property, q: 'Hello World template:Default')
      expect(res).to match_array([default_el])
    end

    it 'filters by multiple templates' do
      res = SearchElementsService.call(property: property, q: 'template:Default,Child Hello World')
      expect(res).to match_array([default_el, child_el])
    end

    it 'looks for slugs in template names, too' do
      res = SearchElementsService.call(property: property, q: 'template:Default,all-options Hello World')
      expect(res).to match_array([default_el, all_options_el])
    end

    it 'will ignore template names that do not exist' do
      res = SearchElementsService.call(property: property, q: 'template:Default,AllOptions Hello World')
      expect(res).to match_array([default_el])
    end
  end

end
