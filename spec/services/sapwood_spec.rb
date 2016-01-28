require 'rails_helper'

RSpec.describe Sapwood do

  before(:each) do
    @config_file = File.join(Rails.root,'config','sapwood.yml')
    @init_config = File.read(@config_file)
  end

  after(:each) do
    File.write(@config_file, @init_config)
  end

  describe '#write_config!' do
    it 'overwrites the rewrite the config file' do
      Sapwood.write_config!
      expect(File.read(@config_file)).to eq(sapwood_as_hash.to_yaml)
    end
  end

end
