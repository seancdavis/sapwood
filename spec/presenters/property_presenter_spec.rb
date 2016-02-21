require 'rails_helper'

RSpec.describe Property, :type => :model do

  let(:property) { create(:property) }

  describe '#label_title' do
    Property.labels.each do |label|
      it "combines the name with #{label}" do
        expect(property.p.label_title(label))
          .to eq("#{property.title} #{label.titleize}")
      end
    end
  end

  describe '#label_new' do
    Property.labels.each do |label|
      it "combines 'new' with a singularized #{label}" do
        expect(property.p.label_new(label))
          .to eq("New #{label.titleize.singularize}")
      end
    end
  end

end
