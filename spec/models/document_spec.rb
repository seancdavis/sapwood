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
#

require 'rails_helper'

RSpec.describe Document, :type => :model do

  let(:document) { create(:document) }

  describe '#set_title_if_blank' do
    it 'sets the title automatically' do
      expect(document.title).to eq('Example')
    end
    it 'does not set the title if it already exists' do
      expect(create(:document, :title => 'Title').title).to_not eq('Example')
    end
  end

end
