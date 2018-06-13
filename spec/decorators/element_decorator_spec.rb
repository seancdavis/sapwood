# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Element, type: :model do

  let(:property) { property_with_templates }

  describe '#formatted_date' do
    it 'will format a date attribute' do
      doc = create(:element, :document, property: property)
      expect(doc.formatted_date(:created_at)).to eq(doc.created_at.strftime('%b %d, %Y'))
      expect(doc.formatted_date(:updated_at)).to eq(doc.updated_at.strftime('%b %d, %Y'))
    end
  end

  describe '#uploaded_at' do
    it 'has a formatted uploaded date' do
      doc = create(:element, :document, property: property)
      expect(doc.uploaded_at).to eq(doc.created_at.strftime('%b %d, %Y'))
    end
  end

  describe '#file_type' do
    %w(pdf png).each do |ext|
      it "pulls out the file extension for #{ext} files" do
        url = "#{Rails.root}/spec/support/example.#{ext}"
        doc = create(:element, :document, property: property, url: url)
        expect(doc.file_type).to eq(ext)
      end
    end
  end

end
