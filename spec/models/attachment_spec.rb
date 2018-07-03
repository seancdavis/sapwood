require 'rails_helper'

RSpec.describe Attachment, type: :model do

  let(:attachment) { create(:attachment) }

  # ---------------------------------------- | Title

  describe '#set_title_if_blank' do
    it 'sets the title if it does not exist' do
      expect(attachment.reload.title).to eq('Bill Murray')
    end
    it 'does not change a set title' do
      attachment = create(:attachment, title: 'My Title')
      expect(attachment.reload.title).to eq('My Title')
    end
  end

  # ---------------------------------------- | Filename

  describe '#filename' do
    it 'returns the entire filename by default' do
      expect(attachment.filename).to eq('Bill Murray.jpg')
    end
    it 'will omit the extension if "false" is passed' do
      expect(attachment.filename(false)).to eq('Bill Murray')
    end
  end

  # ---------------------------------------- | Images

  describe '#image?' do
    it 'returns true when the extname is an image type' do
      IMAGE_EXTENSIONS.each do |ext|
        a = create(:attachment, url: "https://my.cdn/folder/filename.#{ext}")
        expect(a.image?).to eq(true)
      end
    end
    it 'returns false when extname is not image type' do
      a = create(:attachment, url: "https://my.cdn/folder/filename.pdf")
      expect(a.image?).to eq(false)
    end
    it 'returns false when no extname' do
      a = create(:attachment, url: "https://my.cdn/folder/filename")
      expect(a.image?).to eq(false)
    end
    it 'is case-insensitive' do
      IMAGE_EXTENSIONS.each do |ext|
        a = create(:attachment, url: "https://my.cdn/folder/filename.#{ext.upcase}")
        expect(a.image?).to eq(true)
      end
    end
  end

  # ---------------------------------------- | JSON

  describe '#as_json' do
    it 'only includes id, title, url' do
      expect(attachment.as_json.keys).to match_array(%i{id title url})
    end
  end

end
