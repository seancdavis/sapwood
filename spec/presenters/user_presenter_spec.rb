require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { create(:user) }

  describe '#name' do
    it 'returns the email when the name is blank' do
      user = create(:user, :name => nil)
      expect(user.p.name).to eq(user.email)
    end
    it 'returns the name when present' do
      expect(user.p.name).to eq(user.name)
    end
  end

end