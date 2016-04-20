require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do

  describe '#welcome' do
    before(:each) do
      remove_config
      @user = create(:user)
      @mail = UserMailer.welcome(@user)
    end
    it 'sends from the settings default' do
      email = Sapwood.config.default_from.split('<')[-1][0..-2]
      expect(@mail.from).to eq([email])
    end
    it 'sends to the user' do
      expect(@mail.to).to eq([@user.email])
    end
    it 'renders a subject' do
      expect(@mail.subject).to eq('Welcome to Sapwood!')
    end
    it 'has a link to start using Sapwood' do
      path = "#{@user.id}/#{@user.sign_in_id}/#{@user.sign_in_key}"
      expect(@mail.body.encoded).to include(path)
    end
  end

end
