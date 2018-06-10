# frozen_string_literal: true

require 'rails_helper'

describe ImportElements do

  let(:property) { property_with_templates }
  let(:template_name) { 'All Options' }
  let(:csv) { File.read("#{Rails.root}/spec/support/import.csv") }

  it 'requires csv as an argument' do
    expect {
      ImportElements.call(property_id: property.id,
                          template_name: template_name)
    }.to raise_error(RuntimeError)
  end

  it 'requires property_id as an argument' do
    expect {
      ImportElements.call(csv: csv,
                          template_name: template_name)
    }.to raise_error(RuntimeError)
  end

  it 'requires template_name as an argument' do
    expect {
      ImportElements.call(csv: csv,
                          property_id: property.id)
    }.to raise_error(RuntimeError)
  end

  it 'creates elements when csv is formatted correctly' do
    expect(
      property.elements.find_by_title('Great American Ballpark')).to eq(nil)
    expect(property.elements.find_by_title('Paul Brown Stadium')).to eq(nil)
    expect(property.elements.find_by_title('US Bank Arena')).to eq(nil)
    ImportElements.call(csv: csv, property_id: property.id,
                        template_name: template_name)
    expect(
      property.elements.find_by_title('Great American Ballpark')).to_not eq(nil)
    expect(property.elements.find_by_title('Paul Brown Stadium')).to_not eq(nil)
    expect(property.elements.find_by_title('US Bank Arena')).to_not eq(nil)
  end

end
