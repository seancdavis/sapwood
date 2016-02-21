# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  labels        :json
#  templates_raw :text
#  forms_raw     :text
#

require 'rails_helper'

RSpec.describe Property, :type => :model do

  let(:property) { create(:property) }

  describe '#label' do
    Property.labels.each do |label|
      it "defaults to the titleized versions of itself for #{label}" do
        expect(property.label(label)).to eq(label.titleize)
      end
      it "will return a custom value for #{label}" do
        labels = {
          :elements => "Elements 123",
          :documents => "Documents 123",
          :collections => "Collections 123",
          :responses => "Responses 123"
        }
        property.update!(:labels => labels)
        expect(property.label(label)).to eq(labels[label.to_sym])
      end
    end
  end

end
