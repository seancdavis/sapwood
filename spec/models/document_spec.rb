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
#

require 'rails_helper'

RSpec.describe Document, :type => :model do

  let(:document) { create(:document, :from_system) }

  describe '#set_title_if_blank' do
    it 'sets the title automatically' do
      expect(document.title).to eq('Example')
    end
    it 'does not set the title if it already exists' do
      expect(create(:document, :title => 'Title').title).to_not eq('Example')
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

end
