require 'rails_helper'
require 'fileutils'

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
    file = SapwoodConfig.file
    FileUtils.rm(file)
  end

  after(:each) do
    file = SapwoodConfig.file
    FileUtils.rm(file)
  end

  describe '#self.file and #self.default_file' do
    it 'will create a file if it is missing' do
      file = SapwoodConfig.file
      FileUtils.rm(file)
      # File should not exist
      expect(File.exists?(file)).to eq(false)
      SapwoodConfig.file
      # File should be back
      expect(File.exists?(file)).to eq(true)
    end
    it 'will copy the default file if missing' do
      file = SapwoodConfig.file
      FileUtils.rm(file)
      SapwoodConfig.file
      expect(File.read(file)).to eq(File.read(SapwoodConfig.default_file))
    end
    it 'uses the environment name in the filename' do
      expect(SapwoodConfig.file.split('/').last).to eq('sapwood.test.yml')
    end
  end

  describe '#installed?' do
    it 'defaults to false when missing' do
      expect(Sapwood.installed?).to eq(false)
    end
  end

  describe '#config' do
    it 'has default settings loaded' do
      expect(Sapwood.config.installed?).to eq(false)
    end
    it 'can get to nested settings via OpenStruct' do
      expect(Sapwood.config.send_grid.user_name).to eq('user')
    end
  end

  describe '#write!' do
    it 'will write all settings to file' do
      Sapwood.write!
      expect(File.read(SapwoodConfig.file)).to match('installed?')
    end
  end

  describe '#reload!' do
    it 'will re-read the settings from file' do
      Sapwood.write!
      config = File.read(SapwoodConfig.file)
      # Show that this starts as false
      expect(Sapwood.installed?).to eq(false)
      config.gsub!(/installed\?\:\ false/, 'installed?: true')
      File.write(SapwoodConfig.file, config)
      Sapwood.reload!
      # And then it changes to true
      expect(Sapwood.installed?).to eq(true)
    end
  end

  describe '#set' do
    it 'make setting available via config' do
      Sapwood.set('hello', 'world')
      expect(Sapwood.config.hello).to eq('world')
    end
    it 'will accept a hash as the value and be available via config' do
      Sapwood.set('hw', 'hello' => 'cheese', 'world' => 'farts')
      expect(Sapwood.config.hw.hello).to eq('cheese')
    end
    it 'will accept a hash as the value and write to file' do
      Sapwood.set('hw', 'hello' => 'cheese', 'world' => 'farts')
      Sapwood.write!
      expect(File.read(SapwoodConfig.file)).to match('world: farts')
    end
  end

end
