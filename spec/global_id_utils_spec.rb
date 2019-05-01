require 'spec_helper'

RSpec.describe 'GlobalID extensions' do
  describe 'GlobalID::Locator.locate' do
    it 'invokes GlobalIdUtils::Locator.locate' do
      str = 'gid://fish/NeonTetra/1'

      expect(GlobalIdUtils::Locator).to receive(:locate).with(str)
      GlobalID::Locator.locate(str)
    end
  end

  describe 'GlobalID::Locator.locate_many' do
    it 'invokes GlobalIdUtils::Locator.locate_many' do
      strs = ['gid://fish/NeonTetra/1', 'gid://fish/SiameseFighting/1']

      expect(GlobalIdUtils::Locator).to receive(:locate_many).with(strs, {})
      GlobalID::Locator.locate_many(strs)
    end
  end

  describe 'GlobalID.find!' do
    it 'raises if gid is invalid' do
      expect { GlobalID.find!('//bogus') }.to raise_error(URI::BadURIError)
    end

    it 'delegates to GlobalID.find if gid is valid' do
      str = 'gid://fish/NeonTetra/1'
      gid = GlobalID.new(str)

      expect(GlobalID).to receive(:find).with(gid, {})
      GlobalID.find!(str)
    end
  end

  describe 'GlobalID.find_many' do
    it 'invokes GlobalID::Locator.locate_many with options' do
      strs = ['gid://fish/NeonTetra/1', 'gid://fish/SiameseFighting/1']
      gids = strs.map { |str| GlobalID.parse(str) }

      expect(GlobalID::Locator).to receive(:locate_many).with(gids, ignore_missing: true)
      GlobalID.find_many(strs, ignore_missing: true)
    end
  end

  describe 'GlobalID.find_many!' do
    it 'raises if any gid is invalid' do
      strs = ['gid://fish/NeonTetra/1', '//bogus']

      expect { GlobalID.find_many!(strs) }.to raise_error(URI::BadURIError)
    end

    it 'invokes GlobalID.find_many with options if gids are valid' do
      strs = ['gid://fish/NeonTetra/1', 'gid://fish/SiameseFighting/1']
      gids = strs.map { |str| GlobalID.new(str) }

      expect(GlobalID).to receive(:find_many).with(gids, ignore_missing: true)
      GlobalID.find_many!(strs, ignore_missing: true)
    end
  end
end
