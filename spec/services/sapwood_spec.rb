require 'rails_helper'

# This is listed as a service here, but it really acts as an initializer.
#
# ==> config/initializers/_sapwood.rb
#
# The class that is working is called SapwoodConfig. Sapwood is a contsant that
# is loaded as an instance of Sapwood Config, just so we can speed it up a
# little by storing results.
#
RSpec.describe Sapwood do

  before(:each) do
    @init_config = File.read(SapwoodConfig.file)
  end

  after(:each) do
    File.write(SapwoodConfig.file, @init_config)
  end

  describe '#write!' do
    it 'overwrites the rewrite the config file using config_to_h' do
      Sapwood.write!
      expect(File.read(SapwoodConfig.file)).to eq(Sapwood.config_to_h.to_yaml)
    end
  end

  describe '#installed?' do
    it 'is not installed by default' do
      
    end
  end

end
