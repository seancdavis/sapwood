# == Schema Information
#
# Table name: collections
#
#  id                   :integer          not null, primary key
#  title                :string
#  property_id          :integer
#  item_data            :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  collection_type_name :string
#  field_data           :json             default({})
#

require 'rails_helper'

RSpec.describe Collection, :type => :model do

  context 'with items' do
    before(:each) { @collection = create(:collection, :with_items) }

    # These specs are testing nesting items three levels deep within a
    # collection.

    describe '#element_ids' do
      it 'can retrieve its element_ids' do
        expect(@collection.element_ids).to eq(Element.all.collect(&:id))
      end
    end

    describe '#elements' do
      it 'can retrieve its elements' do
        expect(@collection.elements).to eq(Element.all)
      end
    end

    describe '#as_json' do
      it 'retrieves the items and nests them properly' do
        e = Element.all.to_a
        items = [
          e[0].as_json({}).merge(
            :children => [
              e[1].as_json({})
                .merge(:children => [e[2].as_json({}), e[3].as_json({})])
            ]
          ),
          e[4].as_json({}).merge(:children => [])
        ]
        as_json = { :id => @collection.id, :title => @collection.title,
                    :type => 'Collection', :items => items }
        expect(@collection.as_json({})).to eq(as_json)
      end
    end
  end

end
