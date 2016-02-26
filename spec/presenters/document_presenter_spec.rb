require 'rails_helper'

RSpec.describe Document, :type => :model do

  let(:document) { create(:document) }

  describe '#file_type' do
    %w(pdf png).each do |ext|
      it "pulls out the file extension for #{ext} files" do
        url = "#{Rails.root}/spec/support/example.#{ext}"
        expect(create(:document, :url => url).p.file_type).to eq(ext)
      end
    end
  end

  describe '#uploaded_at' do
    it 'has a formatted uploaded date' do
      expect(document.p.uploaded_at)
        .to eq(document.created_at.strftime('%m.%d.%y'))
    end
  end

end
