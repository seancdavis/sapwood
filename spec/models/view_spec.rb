require 'rails_helper'

RSpec.describe View, type: :model do

  let(:property) { create(:property) }

  describe '#create_slug' do
    it 'automatically creates a slug' do
      view = create(:view, title: 'Hello World')
      expect(view.slug).to eq('hello-world')
    end

    it 'appends the id when the slug is not unique' do
      view_01 = create(:view, property: property, title: 'Hello World')
      view_02 = create(:view, property: property, title: 'Hello World')
      expect(view_02.slug).to eq("hello-world-#{view_02.id}")
    end
  end

end
