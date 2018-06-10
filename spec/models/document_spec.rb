# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id          :integer          not null, primary key
#  title       :string
#  url         :string
#  property_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  archived    :boolean          default(FALSE)
#  processed   :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Document, type: :model do

  let(:document) { create(:document, :from_system) }

  describe '#set_title_if_blank' do
    it 'sets the title automatically' do
      expect(document.title).to eq('Example')
    end
    it 'does not set the title if it already exists' do
      expect(create(:document, title: 'Title').title).to_not eq('Example')
    end
  end

  describe '#as_json' do
    it 'has references to all necessary attributes' do
      json = document.as_json({})
      expect(json[:id]).to eq(document.id)
      expect(json[:title]).to eq(document.title)
      expect(json[:url]).to eq(document.url)
    end
  end

  describe '#filename, #filename_no_ext, #file_ext' do
    let(:document) { build(:document) }
    it 'returns appropriate filename parts' do
      expect(document.filename).to eq('178947853882959841_1454569459.jpg')
      expect(document.filename_no_ext).to eq('178947853882959841_1454569459')
      expect(document.file_ext).to eq('jpg')
    end
  end

  describe '#safe_url, #uri, #s3_base, #s3_dir' do
    let(:document) { build(:document, :from_s3) }
    it 'returns appropraite uri segments' do
      expect(document.safe_url).to eq('https://sapwood.s3.amazonaws.com/development/properties/1/xxxxxx-xxxxxx/Bill%20Murray.jpg')
      expect(document.uri).to eq(URI.parse(document.safe_url))
      expect(document.s3_base).to eq('https://sapwood.s3.amazonaws.com')
      expect(document.s3_dir).to eq('development/properties/1/xxxxxx-xxxxxx')
    end
  end

  describe '#version' do
    let(:document) { build(:document, :from_s3) }
    it 'returns the main URL if it has not been processed' do
      expect(document.version(:large)).to eq('https://sapwood.s3.amazonaws.com/development/properties/1/xxxxxx-xxxxxx/Bill%20Murray.jpg')
    end
    it 'returns the correct url for a version with and without crop' do
      document.processed = true
      expect(document.version(:large)).to eq('https://sapwood.s3.amazonaws.com/development/properties/1/xxxxxx-xxxxxx/Bill%20Murray_large.jpg')
      expect(document.version(:large, true)).to eq('https://sapwood.s3.amazonaws.com/development/properties/1/xxxxxx-xxxxxx/Bill%20Murray_large_crop.jpg')
    end
  end

end
